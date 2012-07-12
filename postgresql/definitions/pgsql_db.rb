define :pgsql_db, :action => :create, :owner => "postgres" do

    db_name = params[:name]
    db_owner = params[:owner]

    bash "create database #{db_name}" do
        user "postgres"
        code <<-EOH
            psql postgres -tAc "SELECT 1 FROM pg_catalog.pg_database WHERE datname = '#{db_name}'" | grep -q 1 ||
            createdb --encoding UTF8 --locale=en_US.UTF-8 --template template0 --owner #{db_owner} #{db_name}
        EOH
    end
end
