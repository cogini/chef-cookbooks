define :mysql_db, :action => :create, :owner => 'root', :host => 'localhost' do

    db_name = params[:name]
    owner = params[:owner]
    host = params[:host]
    root_password = node[:mysql][:server_root_password]

    bash "create database #{db_name}" do
        code <<-EOH
mysql -uroot -p#{root_password} <<"EOF"
    CREATE DATABASE IF NOT EXISTS `#{db_name}`;
    ALTER DATABASE #{db_name} CHARACTER SET utf8;
    GRANT ALL ON `#{db_name}`.* TO '#{owner}'@'#{host}';
    FLUSH PRIVILEGES;
EOF
        EOH
    end
end
