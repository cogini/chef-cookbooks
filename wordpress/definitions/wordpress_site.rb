define :wordpress_site do


    include_recipe "php::module_mysql"
    include_recipe "php::module_curl"


    path = params[:name]
    version = params[:version] || node[:wordpress][:version]
    db = params[:db]


    directory path do
        action :create
        recursive true
    end


    download_path = "#{Chef::Config[:file_cache_path]}/wordpress-#{version}.tar.gz"

    remote_file download_path do
        source "http://wordpress.org/wordpress-#{version}.tar.gz"
        action :create_if_missing
    end

    execute 'untar-wordpress' do
        cwd path
        command "tar --strip-components 1 -xzf #{download_path}"
        creates "#{path}/wp-settings.php"
    end


    if db[:host] == 'localhost'

        include_recipe 'mysql::server'
        db_user = db[:user]

        mysql_user db_user do
            password db[:password]
        end

        mysql_db db[:database] do
            owner db_user
        end
    end

    template "#{path}/wp-config.php" do
        mode '644'
        source 'wp-config.php.erb'
        cookbook 'wordpress'
        variables({
            :db => db,
        })
    end
end
