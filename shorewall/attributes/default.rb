set[:shorewall][:rule_defaults] = {
    :action => 'ACCEPT',
    :source => 'all',
    :destination => '$FW',
    :protocol => 'tcp',
    #:ports => %w{ http https ssh },
    :source_ports => '-',
    :original_destination => '-',
    :rate_limit => '-',
}


default[:shorewall][:rules] = [{
    'ports' => %w{ http https ssh }
}]
