case node[:platform]

when 'ubuntu'

    default[:dkim][:key_dir] = '/etc/mail'
    default[:dkim][:selector] = 'mail'
    default[:dkim][:user] = 'root'

    if node[:platform_version].to_f < 10.04
        default[:dkim][:packages] = %w{ dkim-filter }
        default[:dkim][:service] = 'dkim-filter'
        default[:dkim][:config] = '/etc/dkim-filter.conf'
        default[:dkim][:genkey] = 'dkim-genkey'

    else
        default[:dkim][:packages] = %w{
            opendkim
            opendkim-tools
        }
        default[:dkim][:service] = 'opendkim'
        default[:dkim][:config] = '/etc/opendkim.conf'
        default[:dkim][:genkey] = 'opendkim-genkey'
    end

when 'centos'
    default[:dkim][:packages] = %w{ opendkim }
    default[:dkim][:service] = 'opendkim'
    default[:dkim][:config] = '/etc/opendkim.conf'
    default[:dkim][:genkey] = 'opendkim-genkey'
    default[:dkim][:key_dir] = '/etc/opendkim/keys'
    default[:dkim][:selector] = 'default'
    default[:dkim][:user] = 'opendkim'

else
    raise NotImplemented
end
