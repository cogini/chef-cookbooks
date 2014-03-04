case node[:platform]
when 'ubuntu'
    # Origins: security, updates, proposed, backports
    default[:autoupdate][:origins] = [
        "security",
        "updates"
    ]
    default[:autoupdate][:auto_fix_interrupted_dpkg] = true
    default[:autoupdate][:clean_downloaded_packages_interval] = 15
    default[:autoupdate][:email] = "noc@cogini.com"
    default[:autoupdate][:remove_unused_dependencies] = true
    default[:autoupdate][:update_package_lists_interval] = 1
    default[:autoupdate][:upgrade_interval] = 1

when 'centos', 'redhat'
    default[:autoupdate][:check_first] = false
    default[:autoupdate][:check_only] = false
    default[:autoupdate][:download_only] = false
else
    raise NotImplementedError
end

default[:autoupdate][:email] = "admin@example.com"
