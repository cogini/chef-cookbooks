
apt_repository 'git' do
    uri 'http://ppa.launchpad.net/git-core/ppa/ubuntu'
    distribution node[:lsb][:codename]
    components [:main]
    keyserver 'keyserver.ubuntu.com'
    key 'E1DF1F24'
    notifies :run, 'execute[apt-get update]', :immediately
end

package 'git'
