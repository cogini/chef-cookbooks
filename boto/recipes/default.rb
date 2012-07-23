#
# Cookbook Name:: boto
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe "fpm"

version = node.boto.version
chef_cache = Chef::Config[:file_cache_path]
pkg_file = "#{chef_cache}/python-boto-#{version}.rpm"

unless File.exists?(pkg_file)
    bash "build boto" do
        cwd chef_cache
        code <<-EOH
            path_extras="/var/lib/gems/1.8/bin"
            for extra in $(echo $path_extras)
                do
                test -d $extra && test ":$PATH:" != "*:$extra:*" && PATH="$extra:$PATH"
            done
            fpm -s python -t rpm -p #{pkg_file} -v #{version} boto
        EOH
    end
end

package "python-boto" do
    source pkg_file
    options "--nogpgcheck"
end
