include_recipe 'java'


package_from_url node[:elasticsearch][:download_url]

service 'elasticsearch' do
    action [:enable, :start]
end


case node[:platform_family]
when 'rhel'
    template '/etc/sysconfig/elasticsearch' do
        source 'redhat-sysconfig.erb'
        mode '644'
        notifies :restart, 'service[elasticsearch]'
    end
when 'debian'
    template '/etc/default/elasticsearch' do
        source 'debian-default.erb'
        mode '644'
        notifies :restart, 'service[elasticsearch]'
    end
end
