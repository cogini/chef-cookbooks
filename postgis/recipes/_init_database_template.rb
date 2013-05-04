execute 'create_postgis_template' do
  not_if "psql -qAt --list | grep -q '^#{node['postgis']['template_name']}\|'", :user => 'postgres'
  user 'postgres'
  command <<CMD
(createdb -E UTF8 #{node['postgis']['template_name']} -T template0) &&
(psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/postgis-2.0/postgis.sql) &&
(psql -d #{node['postgis']['template_name']} -f `pg_config --sharedir`/contrib/postgis-2.0/spatial_ref_sys.sql)
CMD
  action :run
end
