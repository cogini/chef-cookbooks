case node[:platform_family]
when 'rhel'
    include_recipe 'postgresql::client_redhat'
when 'debian'
    include_recipe 'postgresql::client_debian'
end

link '/usr/bin/pg_config' do
    to "/usr/pgsql-#{node[:postgresql][:version]}/bin/pg_config"
    not_if { File.exist?('/usr/bin/pg_config') }
end

gem_package 'pg'
