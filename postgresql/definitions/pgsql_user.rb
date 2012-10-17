define :pgsql_user, :action => :create, :password => nil, :connlimit => nil do

    username = params[:name]
    password = params[:password]
    connlimit = params[:connlimit]

    bash "create user #{username}" do
        user "postgres"
        code <<-EOH
            psql postgres -tAc "SELECT 1 FROM pg_user WHERE usename='#{username}'" | grep -q 1 ||
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

    if connlimit
        bash "set connection limit for #{username}" do
            user 'postgres'
            code <<-EOH
                echo "ALTER ROLE #{username} CONNECTION LIMIT #{connlimit};" | psql
            EOH
        end
    end

end
