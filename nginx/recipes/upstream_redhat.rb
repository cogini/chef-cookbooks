if node[:platform] == 'centos'
    base_url = 'http://nginx.org/packages/centos/$releasever/$basearch/'
else
    base_url = 'http://nginx.org/packages/rhel/$releasever/$basearch/'
end

# add the nginx upstream repo
yum_repository 'nginx' do
    description 'Nginx upstream repo'
    baseurl base_url
    gpgcheck true
    gpgkey 'http://nginx.org/keys/nginx_signing.key'
    enabled true
    action :create
end
