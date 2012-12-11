#
# Cookbook Name:: nginx
# Attributes:: default
#
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Joshua Timberman (<joshua@opscode.com>)
#
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['nginx']['version'] = '1.0.14'
default['nginx']['dir'] = '/etc/nginx'
default['nginx']['log_dir'] = '/var/log/nginx'
default['nginx']['binary'] = '/usr/sbin/nginx'
default['nginx']['sendfile'] = 'on';

default['nginx']['pid'] = '/var/run/nginx.pid'

default['nginx']['gzip']              = 'on'
default['nginx']['gzip_http_version'] = '1.0'
default['nginx']['gzip_comp_level']   = '2'
default['nginx']['gzip_proxied']      = 'any'
default['nginx']['gzip_types']        = [
  #'text/html', is included by default
  'text/plain',
  'text/css',
  'application/x-javascript',
  'text/xml',
  'application/xml',
  'application/xml+rss',
  'text/javascript',
  'application/javascript',
  'application/json',
]

default['nginx']['keepalive']          = 'on'
default['nginx']['keepalive_timeout']  = 65
default['nginx']['worker_processes']   = cpu['total']
default['nginx']['worker_connections'] = 1024
default['nginx']['server_names_hash_bucket_size'] = 64

default['nginx']['disable_access_log'] = false
default['nginx']['install_method'] = 'package'

default[:nginx][:client_max_body_size] = '1M'
default[:nginx][:types_hash_max_size] = '1024'

case node['platform']
when 'ubuntu'
    default['nginx']['user'] = 'www-data'
    default['nginx']['init_style'] = 'runit'
    if node[:platform_version].to_f >= 12.04
        default[:nginx][:types_hash_max_size] = 2048
    end
when 'redhat','centos','scientific','amazon','oracle','fedora'
    default['nginx']['user']       = 'nginx'
    default['nginx']['init_style'] = 'init'
else
    default['nginx']['user']       = 'www-data'
    default['nginx']['init_style'] = 'init'
end
