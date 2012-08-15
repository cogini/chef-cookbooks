#
# Cookbook Name:: tarsnap
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'basics::cronic'
include_recipe 'fpm'


tarsnap_version = node["tarsnap"]["version"]
chef_cache = Chef::Config[:file_cache_path]
tarsnap_dir = "/root/tarsnap"


pkgs = value_for_platform(
    %w{redhat centos} => {
        "default" => %w{e2fsprogs-devel zlib-devel openssl-devel}
    },
    # Ubuntu
    "default" => %w{e2fslibs-dev zlib1g-dev libssl-dev}
)

pkg_file = value_for_platform(
    %w{redhat centos} => {
        "default" => "#{chef_cache}/tarsnap-#{tarsnap_version}.rpm"
    },
    # Ubuntu
    "default" => "#{chef_cache}/tarsnap-#{tarsnap_version}.deb"
)

pkg_type = pkg_file[-3..-1]


pkgs.each do |pkg|
    package pkg do
        action "install"
    end
end


unless File.exists?(pkg_file)
    remote_file "#{chef_cache}/tarsnap-autoconf-#{tarsnap_version}.tgz" do
        source "https://www.tarsnap.com/download/tarsnap-autoconf-#{tarsnap_version}.tgz"
        action "create_if_missing"
    end

    bash "build_tarsnap" do
        cwd chef_cache
        code <<-EOH
            path_extras="/var/lib/gems/1.8/bin"
            for extra in $(echo $path_extras)
                do
                test -d $extra && test ":$PATH:" != "*:$extra:*" && PATH="$extra:$PATH"
            done
            tar zxvf tarsnap-autoconf-#{tarsnap_version}.tgz
            cd tarsnap-autoconf-#{tarsnap_version}
            ./configure
            make all
            make install DESTDIR=./install
            fpm -s dir -t #{pkg_type} -n tarsnap -v #{tarsnap_version} -p #{pkg_file} -C install .
        EOH
    end
end

package "tarsnap" do
    action :install
    source pkg_file
    provider node[:fpm][:provider]
end


directory tarsnap_dir do
    action :create
end

directory "#{tarsnap_dir}/cachedir" do
    action :create
end

%w{
    tarsnap-env.sh
    tarsnap-backup.sh
    tarsnap-list.sh
    tarsnap-prune.sh
    tarsnap-register-machine.sh
    tarsnap-restore.sh
}.each do |script|
    cookbook_file "#{tarsnap_dir}/#{script}" do
        source script
        mode "0700"
    end
end

file "#{tarsnap_dir}/tarsnap-dirs" do
    content node[:tarsnap][:dirs].join("\n")
end


cron 'tarsnap_backup' do
    hour node[:tarsnap][:cron_time]
    minute '0'
    command "#{node[:cronic]} /root/tarsnap/tarsnap-backup.sh"
end
