unless node[:postfix][:content_filter] == 'amavis:[127.0.0.1]:10024'
    raise 'node[:postfix][:content_filter] must be "amavis:[127.0.0.1]:10024".'
end


if node[:postfix][:enable_clamav]
    include_recipe 'postfix::clamav'
end


%w{
    amavisd-new
    spamassassin
}.each do |pkg|
    package pkg
end


%w{
    amavis
    spamassassin
}.each do |srvc|
    service srvc do
        action [:enable, :start]
    end
end


%w{
    50-user
    15-content_filter_mode
    05-node_id
}.each do |amavis_tmpl|
    template "/etc/amavis/conf.d/#{amavis_tmpl}" do
        source "amavis-#{amavis_tmpl}.erb"
        mode 0644
        notifies :restart, 'service[amavis]'
    end
end


template '/etc/default/spamassassin' do
    mode 0644
    notifies :restart, 'service[spamassassin]'
end

template '/etc/spamassassin/local.cf' do
    source 'spamassassin-local.cf.erb'
    mode 0644
    notifies :restart, 'service[spamassassin]'
end
