default[:aliases] = {}
default[:basics][:package_mask] = []
default[:basics][:package_unmask] = []
default[:cronic] = '/opt/bin/cronic'
default[:network][:hosts] = {}
default[:sudo][:groups] = {}
default[:sudoers] = []
default[:basics][:enable_unattended_upgrades] = false

case node[:platform]

when 'redhat', 'centos', 'amazon'
    default[:admin_group] = 'wheel'
    default[:basics][:packages] = %w(
        bind-utils
        cronie
        emacs-nox
        iotop
        iptraf
        lftp
        logrotate
        logwatch
        lsof
        make
        man
        man-pages
        mlocate
        mutt
        ntp
        perl-Error
        psmisc
        telnet
        unzip
        vim-enhanced
        wget
        zip
    )
    default[:basics][:epel_packages] = %w(
        ack
        atop
        bash-completion
        byobu
        fortune-mod
        htop
        iftop
        tmux
    )

when 'ubuntu'
    default[:admin_group] = 'admin'
    default[:basics][:package_mask] = %w{
        apt-listchanges
        consolekit
    }
    default[:basics][:packages] = %w{
        ack-grep
        apticron
        atop
        bash-completion
        byobu
        dnsutils
        emacs23-nox
        fortune-mod
        htop
        iftop
        iotop
        iptraf
        lftp
        locate
        logrotate
        logwatch
        lsof
        make
        man-db
        manpages
        mutt
        ntp
        psmisc
        telnet
        tmux
        unzip
        vim
        wget
        zip
    }
end

# Origins: security, updates, proposed, backports
default[:basics][:unattended_upgrades][:origins] = [
    "security",
    "updates"
]
default[:basics][:unattended_upgrades][:auto_fix_interrupted_dpkg] = true
default[:basics][:unattended_upgrades][:email] = "noc@cogini.com"
deafult[:basics][:unattended_upgrades][:remove_unused_dependencies] = true
deafult[:basics][:unattended_upgrades][:update_package_lists_interval] = 1
default[:basics][:unattended_upgrades][:clean_downloaded_packages_interval] = 15
default[:basics][:unattended_upgrades][:upgrade_interval] = 1
