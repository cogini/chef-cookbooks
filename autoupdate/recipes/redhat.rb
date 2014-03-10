package 'yum-cron'


service 'yum-cron' do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
end

template '/etc/sysconfig/yum-cron' do
    mode '644'
    notifies :reload, 'service[yum-cron]'
end


