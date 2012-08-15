default[:cronic] = '/opt/bin/cronic'

default[:network][:gateway] = nil
default[:network][:hosts] = {}

default[:basics][:package_mask] = []
default[:basics][:package_unmask] = []
default[:basics][:root_alias] = 'root'

default[:ssh][:ports] = [22]
default[:ssh][:enable_password] = false
default[:ssh][:hostkeys] = %w{
    /etc/ssh/ssh_host_rsa_key
    /etc/ssh/ssh_host_dsa_key
}

default[:sudoers] = []

case node[:platform]

when 'redhat', 'centos', 'amazon'
    default[:admin_group] = 'wheel'
    default[:ssh][:service] = 'sshd'
    default[:basics][:packages] = %w(
        bind-utils
        byobu
        iptraf
        mlocate
        logrotate
        logwatch
        lsof
        make
        man
        man-pages
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
    if node[:platform] = 'centos' && node[:platform_version].to_f >= 6
        # byobu not on centos6 yet
        default[:basics][:packages].delete('byobu')
    end

when 'ubuntu'
    default[:admin_group] = 'admin'
    default[:ssh][:service] = 'ssh'
    default[:basics][:package_mask] = %w{
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
        iptraf
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
    if node[:platform_version].to_f >= 12.04
        default[:ssh][:hostkeys] = %w{
            /etc/ssh/ssh_host_rsa_key
            /etc/ssh/ssh_host_dsa_key
            /etc/ssh/ssh_host_ecdsa_key
        }
    end
end
