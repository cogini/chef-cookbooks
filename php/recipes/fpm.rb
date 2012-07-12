# Add the repo if needed

case node[:platform]

when "centos"
    if node[:platform_version].to_i == 6
        include_recipe "yum::remi"
    end

when "ubuntu"
    node.php.conf_dir = '/etc/php5/fpm'
    if node['platform_version'].to_f <= 10.04
        apt_repository "ondrej-php5" do
            uri "http://ppa.launchpad.net/ondrej/php5/ubuntu"
            distribution node['lsb']['codename']
            components ["main"]
            keyserver "keyserver.ubuntu.com"
            key "E5267A6C"
            action :add
        end
    end

end


package node.php.fpm_package do
    action :install
end

template node.php.fpm_config do
    source node.php.fpm_template
    mode "0644"
end

template "#{node.php.conf_dir}/php.ini" do
    source "php.ini.erb"
    mode "0644"
end

service node.php.fpm_service do
    action [:enable, :restart]
end
