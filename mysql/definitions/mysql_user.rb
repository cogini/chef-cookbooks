define :mysql_user, :action => :create, :password => nil, :host => 'localhost' do

    username = params[:name]
    password = params[:password]
    host = params[:host]
    root_password = node[:mysql][:server_root_password]

    bash "create user #{username}" do
        code <<-EOH
mysql -uroot -p#{root_password} <<EOF
    GRANT USAGE ON *.* TO '#{username}'@'#{host}';
EOF
        EOH
    end

    bash "set password for #{username}" do
        code <<-EOH
mysql -uroot -p#{root_password} <<EOF
    UPDATE mysql.user SET password = PASSWORD('#{password}') where user = '#{username}';
    FLUSH PRIVILEGES;
EOF
        EOH
        only_if { password }
    end

end
