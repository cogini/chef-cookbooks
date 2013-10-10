#
# Author:: Joshua Timberman(<joshua@opscode.com>)
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright 2009-2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'postfix::vanilla'

excluded_maps = %w{ mysql pgsql proxy }
postfix = node[:postfix]


if postfix[:dkim]
  include_recipe 'dkim'
end


case node[:platform]
when "redhat", "centos", "amazon", "scientific"
  service "sendmail" do
    action :nothing
  end
  execute "switch_mailer_to_postfix" do
    command "/usr/sbin/alternatives --set mta /usr/sbin/sendmail.postfix"
    notifies :stop, resources(:service => "sendmail")
    notifies :start, resources(:service => "postfix")
    not_if "/usr/bin/test /etc/alternatives/mta -ef /usr/sbin/sendmail.postfix"
  end
end


# These are needed for the chroot

['/etc/services', '/etc/resolv.conf'].each do |etc_file|

    chrooted_file = "/var/spool/postfix/#{etc_file}"

    directory File.dirname(chrooted_file) do
        action :create
        recursive true
    end

    file chrooted_file do
        content IO.read(etc_file)
    end
end


%w{main master}.each do |cfg|
  template "/etc/postfix/#{cfg}.cf" do
    source "#{cfg}.cf.erb"
    owner "root"
    group "root"
    mode 0644
    notifies :restart, resources(:service => "postfix")
  end
end

include_recipe 'postfix::transport_maps'


unless postfix[:virtual_mailbox_domains].empty?

  virtual_mailbox_base = postfix[:virtual_mailbox_base]

  [postfix[:virtual_alias_maps], postfix[:virtual_mailbox_maps]].each do |map|
    execute "postmap #{map}" do
      not_if { map.empty? or excluded_maps.include?(map.split(":")[0]) }
    end
  end

  group "virtual" do
    gid postfix[:virtual_gid_static]
    system true
  end

  user "virtual" do
    gid postfix[:virtual_gid_static]
    uid postfix[:virtual_uid_static]
    system true
  end

  directory virtual_mailbox_base do
    action :create
    recursive true
    owner postfix[:virtual_uid_static]
    group postfix[:virtual_gid_static]
    mode '0700'
    not_if { virtual_mailbox_base.empty? }
  end

  postfix[:virtual_mailbox_domains].each do |domain|
    directory "#{virtual_mailbox_base}/#{domain}" do
      action :create
      recursive true
      owner postfix[:virtual_uid_static]
      group postfix[:virtual_gid_static]
      mode '0700'
      not_if { excluded_maps.include?(domain.split(":")[0]) }
    end
  end
end


unless postfix[:sender_dependent_relayhosts].empty?

  map_file = postfix[:sender_dependent_relayhost_maps]
  map_file = map_file.sub('hash:', '')

  execute 'postmap-sender_dependent_relayhost_maps' do
    command "postmap #{map_file}"
    action :nothing
  end

  template map_file do
    source 'sender_dependent_relayhost_maps.erb'
    mode 0400
    notifies :run, "execute[postmap-sender_dependent_relayhost_maps]", :immediately
    notifies :restart, "service[postfix]"
  end
end


if postfix[:enable_spf]
  unless postfix[:smtpd_recipient_restrictions].include? 'check_policy_service unix:private/policy-spf'
    raise 'node[:postfix][:smtpd_recipient_restrictions] must contain "check_policy_service unix:private/policy-spf"'
  end
  package "postfix-policyd-spf-python"
end


service "postfix" do
  action :start
end
