default[:dkim][:selector] = 'mail'

case node[:platform]
when 'ubuntu'
    if node[:platform_version].to_f < 10.04
        default[:dkim][:package] = 'dkim-filter'
        default[:dkim][:service] = 'dkim-filter'
        default[:dkim][:config] = '/etc/dkim-filter.conf'
        default[:dkim][:genkey] = 'dkim-genkey'
    else
        default[:dkim][:package] = 'opendkim'
        default[:dkim][:service] = 'opendkim'
        default[:dkim][:config] = '/etc/opendkim.conf'
        default[:dkim][:genkey] = 'opendkim-genkey'
    end
end
