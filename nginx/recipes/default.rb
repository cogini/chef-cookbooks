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

package 'nginx' do
    # :install (default action) will not upgrade to the newest version if Nginx
    # is already installed. :upgrade may cause some subtle problems but I guess
    # it's OK for now.
    action :upgrade
    version node[:nginx][:version]
end

include_recipe 'nginx::commons'
service 'nginx' do
    action [:enable, :start]
end
