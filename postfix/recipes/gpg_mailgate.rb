# TODO: Make this work with Amavis
unless node[:postfix][:content_filter] == 'gpg-mailgate'
    raise 'node[:postfix][:content_filter] must be "gpg-mailgate".'
end

unless node[:postfix][:master_partials].include? 'gpg-mailgate-master.cf.erb'
    raise 'node[:postfix][:master_partials] must include "gpg-mailgate-master.cf.erb".'
end


install_dir = '/opt/gpg-mailgate'


git_clone 'https://github.com/ajgon/gpg-mailgate.git' do
    destination install_dir
    version 'd0c8e367ab087df8f1cb0ee160324a8bf10fdac6'
end


template '/etc/gpg-mailgate.conf' do
    mode '644'
end


link '/usr/local/bin/gpg-mailgate.py' do
    to "#{install_dir}/gpg-mailgate.py"
end

link '/usr/lib/python2.7/GnuPG' do
    to "#{install_dir}/GnuPG"
end


include_recipe 'postfix'
