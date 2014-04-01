#
# Cookbook Name:: yum
# Recipe:: postgresql91
#
# Copyright 2012, Cogini
#

package_from_url node[:yum][:postgresql_repo_url]


template '/etc/yum.repos.d/CentOS-Base.repo' do
    source 'postgresql-CentOS-Base.repo.erb'
    mode '0644'
end
