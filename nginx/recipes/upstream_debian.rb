if node[:platform] == 'ubuntu'
    apt_repository 'nginx' do
        uri 'http://ppa.launchpad.net/nginx/stable/ubuntu/'
        distribution node[:lsb][:codename]
        components [:main]
        keyserver 'keyserver.ubuntu.com'
        key 'C300EE8C'
    end

else
    apt_repository 'nginx' do
        uri 'http://nginx.org/packages/debian/'
        distribution node[:lsb][:codename]
        components ['nginx']
        key 'http://nginx.org/keys/nginx_signing.key'
    end
end
