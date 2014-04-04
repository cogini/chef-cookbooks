if node[:postgresql][:version] == node[:postgresql][:repo_version]
    package 'postgresql-client'
else
    apt_repository 'pgdg' do
        uri 'http://apt.postgresql.org/pub/repos/apt/'
        distribution "#{node[:lsb][:codename]}-pgdg"
        components [:main]
        keyserver 'keyserver.ubuntu.com'
        key 'ACCC4CF8'
    end
    package "postgresql-client-#{node[:postgresql][:version]}"
end

# TODO HXP: Make sure that the right version of libpq-dev is installed
%w{
    libpq-dev
    make
}.each do |p|
    package p
end
