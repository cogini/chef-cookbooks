include_recipe 'java'


package_from_url node[:elasticsearch][:download_url]


if node[:platform_family] == 'rhel'
    template '/etc/sysconfig/elasticsearch' do
        source 'redhat-sysconfig.erb'
        mode '644'
    end
end
