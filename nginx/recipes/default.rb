case node[:platform_family]
when 'rhel'
    include_recipe 'yum::epel'
end

version = node[:nginx][:version]

# Use upstream repo if desired version doesn't match distro provided version:
if version != node[:nginx][:repo_version]
    case node[:platform_family]
    when 'rhel'
        include_recipe 'nginx::upstream_redhat'
    when 'debian'
        include_recipe 'nginx::upstream_debian'
    end

end

package 'nginx'

include_recipe 'nginx::commons'
service 'nginx' do
    action [:enable, :start]
end
