#
# Cookbook Name:: amanda
# Recipe:: default
#

include_recipe 'apt'
include_recipe 'gdebi'


amanda = node[:amanda]
key_dir = "#{amanda[:home]}/.ssh"
app_user = amanda[:app_user]
app_group = amanda[:app_group]
arch = node[:kernel][:machine] =~ /x86_64/ ? 'amd64' : 'i386'


if node[:platform] == 'ubuntu' and node[:platform_version].to_f == 12.04
    amanda_pkg = "amanda-backup-server_#{amanda[:version]}-1Ubuntu1204_#{arch}.deb"
    pkg_file = "#{Chef::Config[:file_cache_path]}/#{amanda_pkg}"
else
    raise NotImplementedError
end


remote_file pkg_file do
    source "http://www.zmanda.com/downloads/community/Amanda/#{amanda[:version]}/Ubuntu-12.04/#{amanda_pkg}"
    action :create_if_missing
end

gdebi_package amanda_pkg do
    source pkg_file
    action :install
end


include_recipe 'amanda::common'


%w{ daily weekly monthly }.each do |type|

    base_dir = amanda[type][:base_dir]

    %w{ tapes indexes info logs holding }.each do |dir|
        directory "#{base_dir}/#{dir}" do
            owner app_user
            group app_group
            mode '755'
            recursive true
        end
    end

    for i in 1..amanda[:number_of_tapes] do
        directory "#{base_dir}/tapes/slot#{i}" do
            owner app_user
            group app_group
            mode '755'
            recursive true
        end
    end
end


template '/etc/amanda/amanda-client.conf' do
    source 'amanda-client.conf.erb'
    owner app_user
    group app_group
    mode '600'
end

template '/etc/amanda/amanda.conf.inc' do
    source 'amanda.conf.inc.erb'
    owner app_user
    group app_group
    mode '600'
end


template "#{key_dir}/config" do
    owner app_user
    group app_group
    source 'ssh-config.erb'
    mode '644'
end

execute 'Generate ssh key' do
    user app_user
    command "ssh-keygen -q -N '' -t rsa -f #{key_dir}/id_rsa"
    not_if { File.exists?("#{key_dir}/id_rsa") }
end


amanda[:backup_locations].each do |client|
    execute "Add #{client[:hostname]} to list of known hosts" do
        user app_user
        command "ssh -o StrictHostKeyChecking=no #{client[:hostname]}"
        not_if { client[:hostname] == 'localhost' }
    end
end


%w{ daily weekly monthly }.each do |backup_type|

    config_dir = "/etc/amanda/#{backup_type}"

    directory config_dir do
        owner app_user
        group app_group
        mode '750'
    end

    template "#{config_dir}/disklist" do
        source 'disklist.erb'
        owner app_user
        group app_group
        mode '640'
    end

    template "#{config_dir}/amanda.conf" do
        source "amanda-#{backup_type}.conf.erb"
        owner app_user
        group app_group
        mode '640'
    end
end


backup_script = "#{amanda[:home]}/amanda-backup.sh"

template backup_script do
    source "amanda-backup.sh.erb"
    owner app_user
    group app_group
    mode '700'
end

cron 'Amanda backup' do
    minute 0
    hour amanda[:cron_time]
    user app_user
    command backup_script
end


retry_script = "#{amanda[:home]}/amanda-retry.sh"

template retry_script do
    mode '755'
end

cron 'Amanda retry' do
    minute 0
    hour '*/3'
    user app_user
    command "#{node[:cronic]} #{retry_script}"
end


check_script = "#{amanda[:home]}/amanda-check.py"

template check_script do
    mode '755'
end

cron 'Amanda check' do
    minute 0
    hour 6
    command "#{node[:cronic]} #{check_script}"
end
