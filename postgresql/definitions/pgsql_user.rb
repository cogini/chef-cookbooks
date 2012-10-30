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

    bash "set password for #{username}" do
        user 'postgres'
        code <<-EOH
psql <<EOF
    ALTER ROLE "#{username}" ENCRYPTED PASSWORD '#{password}';
EOF
        EOH
        only_if { password }
    end

    bash "set connection limit for #{username}" do
        user 'postgres'
        code <<-EOH
psql <<EOF
    ALTER ROLE "#{username}" CONNECTION LIMIT #{connlimit};
EOF
        EOH
        only_if { connlimit }
    end

end
