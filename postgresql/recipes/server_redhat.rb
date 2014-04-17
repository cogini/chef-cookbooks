#
# Cookbook Name:: postgresql
# Recipe:: server
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Lamont Granquist (<lamont@opscode.com>)
# Copyright 2009-2011, Opscode, Inc.
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

include_recipe "postgresql::client"


pg_dir = node[:postgresql][:dir]


# Create a group and user like the package will.
# Otherwise the templates fail.

group "postgres" do
  gid 26
end

user "postgres" do
  shell "/bin/bash"
  comment "PostgreSQL Server"
  home "/var/lib/pgsql"
  gid "postgres"
  system true
  uid 26
  supports :manage_home => false
end

if node[:postgresql][:version] == node[:postgresql][:repo_version]
  package "postgresql-server"
else
  package "postgresql#{node[:postgresql][:version].split('.').join}-server"
end

if node[:postgresql][:version] == node[:postgresql][:repo_version]
  service_pg = "postgresql"
else
  service_pg = "postgresql-#{node[:postgresql][:version]}"
end

if node[:postgresql][:is_slave]
  execute "pg_basebackup -h #{node[:postgresql][:master_host]} -D . -U replication --xlog" do
    cwd pg_dir
    user "postgres"
    not_if { ::FileTest.exist?(File.join(pg_dir, "PG_VERSION")) }
  end
else
  execute "/sbin/service #{service_pg} initdb" do
    not_if { ::FileTest.exist?(File.join(pg_dir, "PG_VERSION")) }
  end
end

template "#{pg_dir}/postgresql.conf" do
  source "redhat.postgresql.conf.erb"
  owner "postgres"
  group "postgres"
  mode '600'
  notifies :restart, "service[postgresql]"
end

template "#{pg_dir}/recovery.conf" do
  source "recovery.conf.erb"
  owner "postgres"
  group "postgres"
  mode '600'
  only_if { node[:postgresql][:is_slave] }
end

service "postgresql" do
  service_name service_pg
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end
