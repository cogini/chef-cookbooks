include_recipe 'yum::postgresql'

if node[:postgresql][:version] == node[:postgresql][:repo_version]
    package 'postgresql-devel'
else
    package "postgresql#{node[:postgresql][:version].split('.').join}-devel"
end
