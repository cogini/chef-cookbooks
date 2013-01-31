#
# Cookbook Name:: supervisor
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe "fpm"

supervisor_version = node[:supervisor][:version]
chef_cache = Chef::Config[:file_cache_path]
pkg_file = "#{chef_cache}/python-supervisor-#{supervisor_version}.rpm"

unless File.exists?(pkg_file)
    bash "build supervisor" do
        cwd chef_cache
        code <<-EOH
            path_extras="/var/lib/gems/1.8/bin"
            for extra in $(echo $path_extras)
                do
                test -d $extra && test ":$PATH:" != "*:$extra:*" && PATH="$extra:$PATH"
            done
            fpm -s python -t rpm -p #{pkg_file} -v #{supervisor_version} supervisor
        EOH
    end
end

package "python-supervisor" do
    source pkg_file
    options "--nogpgcheck"
end

template "/etc/init.d/supervisord" do
    source "_etc_init.d_supervisord.erb"
    mode "0755"
end

template "/etc/supervisord.conf" do
    source "_etc_supervisord.conf.erb"
    mode "0644"
end

service "supervisord" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
end
