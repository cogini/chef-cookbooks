# XXX HXP: Maybe using `yum_repository` is a better idea
repo_rpm_url = {
    5 => {
        '9.3' => 'http://yum.postgresql.org/9.3/redhat/rhel-5-x86_64/pgdg-centos93-9.3-1.noarch.rpm',
        '9.2' => 'http://yum.postgresql.org/9.2/redhat/rhel-5-x86_64/pgdg-centos92-9.2-6.noarch.rpm',
        '9.1' => 'http://yum.postgresql.org/9.1/redhat/rhel-5-x86_64/pgdg-centos91-9.1-4.noarch.rpm',
        '9.0' => 'http://yum.postgresql.org/9.0/redhat/rhel-5-x86_64/pgdg-centos90-9.0-5.noarch.rpm'
    },
    6 => {
        '9.3' => 'http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-centos93-9.3-1.noarch.rpm',
        '9.2' => 'http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm',
        '9.1' => 'http://yum.postgresql.org/9.1/redhat/rhel-6-x86_64/pgdg-centos91-9.1-4.noarch.rpm',
        '9.0' => 'http://yum.postgresql.org/9.0/redhat/rhel-6-x86_64/pgdg-centos90-9.0-5.noarch.rpm'
    }
}[node[:platform_version].to_i][node[:postgresql][:version]]
package_from_url repo_rpm_url

if node[:postgresql][:version] == node[:postgresql][:repo_version]
    package 'postgresql-devel'
else
    package "postgresql#{node[:postgresql][:version].split('.').join}-devel"
end
