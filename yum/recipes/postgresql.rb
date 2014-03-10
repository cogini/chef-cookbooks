#
# Cookbook Name:: yum
# Recipe:: postgresql91
#
# Copyright 2012, Cogini
#

pg_version = node[:postgresql][:version]

cookbook_file '/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG' do
    mode '644'
    action :create
end

template "/etc/yum.repos.d/pgdg-#{pg_version}-#{node[:platform]}.repo" do
    mode '644'
    source 'repo-postgresql.erb'
end


# Why is it here instead of default recipe?
template '/etc/yum.repos.d/CentOS-Base.repo' do
    source 'postgresql-CentOS-Base.repo.erb'
    mode '0644'
end
