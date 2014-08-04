version = node[:collectd][:version]

node[:collectd][:packages].each do |p|
    # The packages are build using
    # https://github.com/collectd/collectd/blob/master/contrib/redhat/collectd.spec
    package_from_url "http://packages.cogini.com/#{p}-#{version}-1.el6.i686.rpm"
end


service 'collectd' do
    action [:enable, :start]
end


template '/etc/collectd.conf' do
    mode '644'
    notifies :restart, 'service[collectd]'
end

template '/usr/share/collectd/types.db' do
    mode '644'
    notifies :restart, 'service[collectd]'
end
