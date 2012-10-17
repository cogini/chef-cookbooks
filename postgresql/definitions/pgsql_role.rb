define :pgsql_role, :action => :create, :options => [] do

    role_name = params[:name]
    options = params[:options]

    bash "create role #{role_name}" do
        user "postgres"
        code <<-EOH
            psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{role_name}'" | grep -q 1 ||
            psql postgres -tAc "CREATE ROLE #{role_name} #{options.join(' ')}"
        EOH
    end
end
