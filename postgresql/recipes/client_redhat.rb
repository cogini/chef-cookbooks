version = node[:postgresql][:version]

yum_repository "pgdg-#{version}" do
    baseurl "http://yum.pgrpms.org/#{version}/redhat/rhel-$releasever-$basearch"
    description "PostgreSQL #{version}"
    gpgkey 'http://yum.postgresql.org/RPM-GPG-KEY-PGDG'
end

if node[:postgresql][:version] == node[:postgresql][:repo_version]
    package 'postgresql-devel'
else
    package "postgresql#{node[:postgresql][:version].split('.').join}-devel"
end
