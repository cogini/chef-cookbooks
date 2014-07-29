case node[:platform_family]
when 'rhel'
    set[:mysql][:ruby_module_package] = 'ruby-mysql'
when 'debian'
    set[:mysql][:ruby_module_package] = 'libmysql-ruby'
end

if node[:platform] == 'ubuntu' and node[:platform_version].to_f >= 12.04
    set[:mysql][:ruby_module_package] = 'ruby-mysql'
end
