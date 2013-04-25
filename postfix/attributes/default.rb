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

default[:postfix] = {
    :aliases => {},
    :content_filter => '',
    :disable_dns_lookups => 'no',
    :inet_protocols => 'all',
    :mail_relay_networks => ['127.0.0.0/8'],
    :mail_type => 'client',
    :mailbox_size_limit => 51200000,
    :message_size_limit => 10240000,
    :multi_environment_relay => false,
    :mydomain => node[:domain],
    :myhostname => node[:fqdn],
    :mynetworks_style => 'subnet',
    :myorigin => '$myhostname',
    :receive_override_options => '',
    :relay_domains => [:$mydestination],
    :relay_recipient_maps => '',
    :relayhost => '',
    :relayhost_role => 'relayhost',
    :smtp_sasl_auth_enable => 'no',
    :smtp_sasl_passwd => '',
    :smtp_sasl_password_maps => 'hash:/etc/postfix/sasl_passwd',
    :smtp_sasl_security_options => 'noanonymous',
    :smtp_sasl_user_name => '',
    :smtp_tls_cafile => '/etc/postfix/cacert.pem',
    :smtp_tls_note_starttls_offer => 'no',
    :smtp_tls_security_level => '',
    :smtp_use_tls => 'yes',
    :smtpd_data_restrictions => [],
    :smtpd_helo_restrictions => [],
    :smtpd_recipient_restrictions => %w{ permit_mynetworks reject_unauth_destination },
    :smtpd_sender_restrictions => [],
    :smtpd_use_tls => 'yes',
    :transport_maps => {},
    :transport_maps_file => 'hash:/etc/postfix/transport',
    :virtual_alias_maps => '',
    :virtual_gid_static => 5000,
    :virtual_mailbox_base => '',
    :virtual_mailbox_domains => [],
    :virtual_mailbox_maps => '',
    :virtual_uid_static => 5000,
}
