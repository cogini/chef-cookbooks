#
# Cookbook Name:: yum
# Attributes:: default
#
# Copyright 2011, Eric G. Wolfe
# Copyright 2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Example: override.yum.exclude = "kernel* compat-glibc*"
default[:yum][:exclude] = Array.new
default[:yum][:installonlypkgs] = Array.new

default[:yum][:epel_release] = case node[:platform_version].to_i
                                  when 6
                                    "6-7"
                                  when 5
                                    "5-4"
                                  when 4
                                    "4-10"
                                  end
default[:yum][:ius_release] = '1.0-8'

default[:yum][:postgresql_repo_url] = {
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
