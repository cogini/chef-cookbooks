define :mysql_db, :action => :create, :owner => 'root', :host => 'localhost' do

    db_name = params[:name]
    owner = params[:owner]
    host = params[:host]
    root_password = node[:mysql][:server_root_password]

    bash "create database #{db_name}" do
        code <<-EOH
            mysql -uroot -p#{root_password} -e "
                CREATE DATABASE IF NOT EXISTS #{db_name};
                GRANT ALL ON #{db_name}.* TO '#{owner}'@'#{host}';
                FLUSH PRIVILEGES;
            "
        EOH
    end
end
