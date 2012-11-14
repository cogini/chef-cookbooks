#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Attribute:: default
#
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

lib_dir = kernel['machine'] =~ /x86_64/ ? 'lib64' : 'lib'

default[:php][:install_method] = 'package'
default[:php][:post_max_size] = "8M"
default[:php][:timezone] = 'UTC'
default[:php][:upload_max_filesize] = "2M"

default[:php][:fpm][:pm] = 'ondemand'
default[:php][:fpm][:process][:max] = 10
default[:php][:fpm][:catch_workers_output] = 'yes'

default[:php][:session][:gc_probability] = 1

case node['platform']
when 'centos', 'redhat', 'fedora', 'amazon'
    default[:php][:conf_dir] = '/etc'
    default[:php][:ext_conf_dir] = '/etc/php.d'
    default[:php][:ext_dir] = "/usr/#{lib_dir}/php/modules"
    default[:php][:fpm][:group] = 'nobody'
    default[:php][:fpm][:slowlog] = '/var/log/php-fpm/www-slow.log'
    default[:php][:fpm][:user] = 'nobody'
    default[:php][:fpm_config] = '/etc/php-fpm.conf'
    default[:php][:fpm_config_template] = 'redhat-php-fpm.conf.erb'
    default[:php][:fpm_packages] = %w{ php-fpm php-cli }
    default[:php][:fpm_pool_config] = '/etc/php-fpm.d/www.conf'
    default[:php][:fpm_service] = 'php-fpm'
when 'debian', 'ubuntu'
    default[:php][:conf_dir] = '/etc/php5/fpm'
    default[:php][:ext_conf_dir] = '/etc/php5/conf.d'
    default[:php][:fpm][:group] = 'www-data'
    default[:php][:fpm][:slowlog] = '/var/log/php5-fpm.log.slow'
    default[:php][:fpm][:user] = 'www-data'
    default[:php][:fpm_config] = '/etc/php5/fpm/php-fpm.conf'
    default[:php][:fpm_config_template] = 'ubuntu-php-fpm.conf.erb'
    default[:php][:fpm_packages] = %w{ php5-fpm php5-cli }
    default[:php][:fpm_pool_config] = '/etc/php5/fpm/pool.d/www.conf'
    default[:php][:fpm_service] = 'php5-fpm'
    default[:php][:session][:gc_probability] = 0
end

default['php']['url'] = 'http://us.php.net/distributions'
default['php']['version'] = '5.3.10'
default['php']['checksum'] = 'ee26ff003eaeaefb649735980d9ef1ffad3ea8c2836e6ad520de598da225eaab'
default['php']['prefix_dir'] = '/usr/local'

default['php']['configure_options'] = %W{--prefix=#{php['prefix_dir']}
                                          --with-libdir=#{lib_dir}
                                          --with-config-file-path=#{php['conf_dir']}
                                          --with-config-file-scan-dir=#{php['ext_conf_dir']}
                                          --with-pear
                                          --enable-fpm
                                          --with-fpm-user=#{php['fpm_user']}
                                          --with-fpm-group=#{php['fpm_group']}
                                          --with-zlib
                                          --with-openssl
                                          --with-kerberos
                                          --with-bz2
                                          --with-curl
                                          --enable-ftp
                                          --enable-zip
                                          --enable-exif
                                          --with-gd
                                          --enable-gd-native-ttf
                                          --with-gettext
                                          --with-gmp
                                          --with-mhash
                                          --with-iconv
                                          --with-imap
                                          --with-imap-ssl
                                          --enable-sockets
                                          --enable-soap
                                          --with-xmlrpc
                                          --with-libevent-dir
                                          --with-mcrypt
                                          --enable-mbstring
                                          --with-t1lib
                                          --with-mysql
                                          --with-mysqli=/usr/bin/mysql_config
                                          --with-mysql-sock
                                          --with-sqlite3
                                          --with-pdo-mysql
                                          --with-pdo-sqlite}
