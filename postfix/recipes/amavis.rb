
%w{
    amavisd-new
    clamav-daemon
    spamassassin
}.each do |pkg|
    package pkg
end

user "clamav" do
    gid "amavis"
    action :modify
end


%w{
    amavis
    clamav-daemon
    spamassassin
}.each do |srvc|
    service srvc do
        action :enable, :start
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
        notifies :restart, "service[amavis]"
    end
end


template "/etc/default/spamassassin" do
    source "spamassassin.erb"
    mode 0644
    notifies :restart, "service[spamassassin]"
end

template "/etc/spamassassin/local.cf" do
    source "spamassassin-local.cf.erb"
    mode 0644
    notifies :restart, "service[spamassassin]"
end


template "/etc/clamav/clamd.conf" do
    source "clamd.conf.erb"
    mode 0644
    notifies :restart, "service[clamav-daemon]"
end
