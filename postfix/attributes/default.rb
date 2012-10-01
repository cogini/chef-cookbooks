#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright:: Copyright (c) 2009, Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default[:postfix][:aliases] = {}
default[:postfix][:inet_protocols] = 'all'
default[:postfix][:mail_relay_networks] = ['127.0.0.0/8']
default[:postfix][:mail_type] = 'client'
default[:postfix][:multi_environment_relay] = false
default[:postfix][:mydomain] = node[:domain]
default[:postfix][:myhostname] = node[:fqdn]
default[:postfix][:myorigin] = '$myhostname'
default[:postfix][:relayhost] = ''
default[:postfix][:relayhost_role] = 'relayhost'
default[:postfix][:smtp_sasl_auth_enable] = 'no'
default[:postfix][:smtp_sasl_passwd] = ''
default[:postfix][:smtp_sasl_password_maps] = 'hash:/etc/postfix/sasl_passwd'
default[:postfix][:smtp_sasl_security_options] = 'noanonymous'
default[:postfix][:smtp_sasl_user_name] = ''
default[:postfix][:smtp_tls_cafile] = '/etc/postfix/cacert.pem'
default[:postfix][:smtp_use_tls] = 'yes'
default[:postfix][:smtpd_use_tls] = 'yes'
default[:postfix][:disable_dns_lookups] = 'no'
default[:postfix][:relay_domains] = [:$mydestination]
default[:postfix][:relay_recipient_maps] = ''
default[:postfix][:smtpd_recipient_restrictions] = %w{ permit_mynetworks reject_unauth_destination }
default[:postfix][:transport_maps] = {}
default[:postfix][:transport_maps_file] = 'hash:/etc/postfix/transport'
