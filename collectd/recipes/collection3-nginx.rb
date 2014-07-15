package_from_url 'http://packages.cogini.com/fcgiwrap-1.0-1.i686.rpm'

include_recipe 'nginx'

template "/etc/nginx/sites-available/collectd-collection3" do
    source 'collection3-nginx.erb'
    mode '644'
    notifies :restart, 'service[nginx]'
end
