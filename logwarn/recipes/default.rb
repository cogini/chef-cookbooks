#
# Cookbook Name:: logwarn
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe "fpm"

logwarn_version = node["logwarn"]["version"]
chef_cache = Chef::Config[:file_cache_path]


pkg_file = value_for_platform(
    %w{redhat centos} => {
        "default" => "#{chef_cache}/logwarn-#{logwarn_version}.rpm"
    },
    # Ubuntu
    "default" => "#{chef_cache}/logwarn-#{logwarn_version}.deb"
)

pkg_type = pkg_file[-3..-1]


unless File.exists?(pkg_file)
    remote_file "#{chef_cache}/logwarn-#{logwarn_version}.tar.gz" do
        source "http://logwarn.googlecode.com/files/logwarn-#{logwarn_version}.tar.gz"
        action :create_if_missing
    end

    bash "build_logwarn" do
        cwd chef_cache
        code <<-EOH
            path_extras="/var/lib/gems/1.8/bin"
            for extra in $(echo $path_extras)
                do
                test -d $extra && test ":$PATH:" != "*:$extra:*" && PATH="$extra:$PATH"
            done
            tar zxvf logwarn-#{logwarn_version}.tar.gz
            cd logwarn-#{logwarn_version}
            ./configure
            make
            make install DESTDIR=./install
            fpm -s dir -t #{pkg_type} -n logwarn -v #{logwarn_version} -p #{pkg_file} -C install .
        EOH
    end
end

package "logwarn" do
    action :install
    source pkg_file
    provider node[:fpm][:provider]
end
