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

service "postfix" do
  supports :status => true, :restart => true, :reload => true
  action :enable
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


postfix = node[:postfix]
virtual_alias_maps = postfix[:virtual_alias_maps]
virtual_mailbox_maps = postfix[:virtual_mailbox_maps]

[virtual_alias_maps, virtual_mailbox_maps].each do |map|
    execute "postmap #{map}" do
        only_if { map }
    end
end


virtual_mailbox_base = postfix[:virtual_mailbox_base]

directory virtual_mailbox_base do
    action :create
    recursive true
    owner postfix[:virtual_uid_static]
    group postfix[:virtual_gid_static]
    mode '0770'
    only_if { virtual_mailbox_base }
end

postfix[:virtual_mailbox_domains].each do |domain|
    directory "#{virtual_mailbox_base}/#{domain}" do
        action :create
        recursive true
        owner postfix[:virtual_uid_static]
        group postfix[:virtual_gid_static]
        mode '0770'
    end
end


service "postfix" do
  action :start
end
