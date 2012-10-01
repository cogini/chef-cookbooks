map_file = '/etc/postfix/transport'

execute 'postmap_transport_maps' do
    command "postmap #{map_file}"
    action :nothing
end

template map_file do
    source 'transport_maps.erb'
    owner 'root'
    group 'root'
    mode 0400
    notifies :run, resources(:execute => 'postmap_transport_maps'), :immediately
    notifies :restart, resources(:service => 'postfix')
end

