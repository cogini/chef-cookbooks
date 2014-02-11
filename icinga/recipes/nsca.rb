unless node[:icinga][:check_external_commands] == 1
    raise 'node[:icinga][:check_external_commands] must be 1.'
end

package 'nsca'

service 'nsca' do
    action [:enable, :start]
end

template '/etc/nsca.cfg' do
    mode '600'
    notifies :restart, 'service[nsca]'
end
