case node[:platform_family]
when 'rhel'
    include_recipe 'postgresql::client_redhat'
when 'debian'
    include_recipe 'postgresql::client_debian'
end

# TODO HXP: This is only needed when using pgdg. However, packages in pgdg use
# update-alternatives so the right way is `sudo update-alternatives --set
# pgsql-pg_dumpall /usr/pgsql-9.2/bin/pg_dumpall`. Also, for some reason
# pg_config is not managed by update-alternatives.
link '/usr/bin/pg_config' do
    to "/usr/pgsql-#{node[:postgresql][:version]}/bin/pg_config"
    not_if { File.exist?('/usr/bin/pg_config') }
end

gem_package 'pg'
