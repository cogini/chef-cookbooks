include_recipe 'apt'


package 'unattended_upgrades'

template '/etc/apt/apt.conf.d/50unattended-upgrades' do
    mode '644'
end

template '/etc/apt/apt.conf.d/10periodic' do
    mode '644'
end
