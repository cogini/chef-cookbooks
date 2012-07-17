define :mysql_user, :action => :create, :password => nil, :host => 'localhost' do

    username = params[:name]
    password = params[:password]
    host = params[:host]
    root_password = node[:mysql][:server_root_password]

    bash "create user #{username}" do
        code <<-EOH
            mysql -uroot -p#{root_password} -e "
                GRANT USAGE ON *.* TO '#{username}'@'#{host}';
            "
        EOH
    end

    bash "set password for #{username}" do
        code <<-EOH
            mysql -uroot -p#{root_password} -e "
                UPDATE mysql.user SET password = PASSWORD('#{password}') where user = '#{username}';
            "
        EOH
        only_if { password }
    end
end
