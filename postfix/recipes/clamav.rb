%w{ clamav-daemon }.each do |pkg|
    package pkg
end

user 'clamav' do
    gid 'amavis'
    action :modify
end


%w{ clamav-daemon }.each do |srvc|
    service srvc do
        action [:enable, :start]
    end
end


template '/etc/clamav/clamd.conf' do
    mode 0644
    notifies :restart, 'service[clamav-daemon]'
end
