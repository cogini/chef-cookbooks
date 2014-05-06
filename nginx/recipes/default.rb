case node[:platform_family]
when 'rhel'
    include_recipe 'yum::epel'
end
package 'nginx'
include_recipe 'nginx::commons'
service 'nginx' do
    action [:enable, :start]
end
