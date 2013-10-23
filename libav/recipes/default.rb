apt_repository 'cogini' do
    uri 'https://pkghub.io/repo/phunehehe/cogini'
    distribution node[:lsb][:codename]
    components ['main']
    key 'https://pkghub.io/gpg.key'
end

package 'libav' do
    action :install
    version node[:libav][:version]
end
