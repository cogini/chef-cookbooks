#
# Cookbook Name:: amanda
# Recipe:: default
#

include_recipe "apt"


amanda = node[:amanda]
amanda_home = "/var/lib/amanda"
key_dir = amanda[:key_dir]
app_user = amanda[:app_user]
app_group = "disk"
config_dir = "/etc/amanda"
dirs = [
  amanda[:dir][:backup_dir],
  amanda[:dir][:holding_dir],
  amanda[:dir][:index_dir],
  amanda[:dir][:info_dir],
  amanda[:dir][:log_dir],
  amanda[:dir][:vtapes_dir],
  amanda[:tape][:part_cache_dir]
]


amanda[:dependencies].each do |pkg|
  package pkg
end


# Only support ubuntu precise for now
case node[:platform]
when "ubuntu"
  arch = node[:kernel][:machine] =~ /x86_64/ ? "amd64" : "i386"
  amanda_pkg = "amanda-backup-#{amanda[:type]}_#{amanda[:version]}-1Ubuntu1204_#{arch}.deb"
else
  raise ArgumentError, "Platform #{node[:platform]} not supported"
end

remote_file "/tmp/#{amanda_pkg}" do
  source "http://www.zmanda.com/downloads/community/Amanda/#{amanda[:version]}/Ubuntu-12.04/#{amanda_pkg}"
  mode 0644
  not_if { File.exists?("#{amanda_home}/installed") }
end

dpkg_package amanda_pkg do
  source "/tmp/#{amanda_pkg}"
  action :install
  not_if { File.exists?("#{amanda_home}/installed") }
end

file "#{amanda_home}/installed" do
  owner app_user
  action :create_if_missing
end


# Set up amanda server
if amanda[:type] == "server"
  # Fix amrecover error
  template "/usr/libexec/amanda/amidxtaped" do
    source "amidxtaped.erb"
    mode 0755
  end

  directory "#{config_dir}/Daily" do
    owner app_user
    group app_group
    mode 0750
  end

  template "#{config_dir}/Daily/disklist" do
    source "disklist-daily.erb"
    owner app_user
    group app_group
    mode 0644
  end

  template "#{config_dir}/Daily/amanda.conf" do
    source "amanda-daily.conf.erb"
    owner app_user
    group app_group
    mode 0644
  end

  dirs.each do |dir|
    directory dir do
      owner app_user
      group app_group
      mode 0755
      recursive true
    end
  end

  for i in 1..amanda[:tapecycle] do
    directory "#{amanda[:dir][:vtapes_dir]}/slot#{i}" do
      owner app_user
      group app_group
      mode 0755
      recursive true
    end
  end

  template "#{config_dir}/amanda-client.conf" do
    source "amanda-client.conf.erb"
    owner app_user
    group app_group
    mode 0600
  end

  amanda[:backup_locations].each do |client|
    ruby_block "Insert #{client[:hostname]} into hosts file" do
      block do
        file = Chef::Util::FileEdit.new("/etc/hosts")
        file.insert_line_if_no_match(client[:hostname], "#{client[:ip]} #{client[:hostname]}")
        file.write_file
      end
    end
  end

  template "#{key_dir}/config" do
    owner app_user
    group app_group
    source "ssh-config.erb"
    mode 0644
  end

  execute "Generate ssh key" do
    user app_user
    command "ssh-keygen -q -N '' -t rsa -f #{key_dir}/id_rsa"
    not_if { File.exists?("#{key_dir}/id_rsa") }
  end

  amanda[:backup_locations].each do |client|
    if client[:hostname] != "localhost"
      execute "Add #{client[:hostname]} to list of known hosts" do
        user app_user
        command "ssh -o StrictHostKeyChecking=no #{client[:hostname]}"
        ignore_failure true
      end
    end
  end

  cron "daily_backup" do
    hour "20"
    mailto "noc@cogini.com"
    user app_user
    command "/usr/sbin/amdump Daily"
  end
end


# Set up amanda client
if amanda[:type] == "client"
  file "#{key_dir}/authorized_keys" do
    owner app_user
    group app_group
    content amanda[:pub_key]
  end
end
