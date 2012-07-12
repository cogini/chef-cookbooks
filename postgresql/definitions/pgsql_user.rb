define :pgsql_user, :action => :create, :password => nil do

    username = params[:name]
    password = params[:password]

    bash "create user #{username}" do
        user "postgres"
        code <<-EOH
            psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{username}'" | grep -q 1 ||
            createuser --no-superuser --no-createdb --no-createrole #{username}
        EOH
    end

    if password
        bash "set password for #{username}" do
            user 'postgres'
            code <<-EOH
                echo "ALTER ROLE #{username} ENCRYPTED PASSWORD '#{password}';" | psql
            EOH
        end
    end
end
