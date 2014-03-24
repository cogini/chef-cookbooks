case node[:platform_family]
when 'debian'
    # Origins: security, updates, proposed, backports
    default[:autoupdate][:origins] = [
        "security",
        "updates"
    ]
    default[:autoupdate][:auto_fix_interrupted_dpkg] = true
    default[:autoupdate][:clean_downloaded_packages_interval] = 15
    default[:autoupdate][:remove_unused_dependencies] = true
    default[:autoupdate][:update_package_lists_interval] = 1
    default[:autoupdate][:upgrade_interval] = 1

when 'rhel'
    default[:autoupdate][:check_first] = false
    default[:autoupdate][:download_only] = false
end

default[:autoupdate][:email] = 'root'
default[:autoupdate][:blacklist] = []
default[:autoupdate][:enable] = false
