default[:aliases] = {}
default[:basics][:package_mask] = []
default[:basics][:package_unmask] = []
default[:cronic] = '/opt/bin/cronic'
default[:network][:gateway] = nil
default[:network][:hosts] = {}
default[:sudo][:groups] = {}
default[:sudoers] = []

case node[:platform]

when 'redhat', 'centos', 'amazon'
    default[:admin_group] = 'wheel'
    default[:basics][:packages] = %w(
        bind-utils
        byobu
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
        fortune-mod
        htop
        iftop
        tmux
    )
    if node[:platform] == 'centos' && node[:platform_version].to_f >= 6
        # byobu not on centos6 yet
        default[:basics][:packages].delete('byobu')
    end

when 'ubuntu'
    default[:admin_group] = 'admin'
    default[:basics][:package_mask] = %w{
        apt-listchanges
        consolekit
        unattended-upgrades
    }
    default[:basics][:packages] = %w{
        ack-grep
        apticron
        atop
        bash-completion
        byobu
        dnsutils
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
    if node[:platform_version].to_f <= 8.4
        default[:basics][:packages] -= %w{ byobu tmux }
    end
end
