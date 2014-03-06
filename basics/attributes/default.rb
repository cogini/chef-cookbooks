default[:aliases] = {}
default[:basics][:package_mask] = []
default[:basics][:package_unmask] = []
default[:cronic] = '/opt/bin/cronic'
default[:network][:hosts] = {}
default[:sudo][:groups] = {}
default[:sudoers] = []

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
