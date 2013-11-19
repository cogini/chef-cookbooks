#
# Author:: Joshua Timberman(<joshua@opscode.com>)
# Cookbook Name:: postfix
# Recipe:: sasl_auth
#
# Copyright 2009, Opscode, Inc.
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

postfix = node[:postfix]

unless postfix[:smtp_sasl_auth_enable] == 'yes' and
       postfix[:smtp_sasl_password_maps] and
       postfix[:smtp_sasl_passwords][0][:password] and
       postfix[:smtp_sasl_passwords][0][:remote] and
       postfix[:smtp_sasl_passwords][0][:username]
  raise %Q(Some required attributes are missing:
    node[:postfix][:smtp_sasl_auth_enable] => 'yes'
    node[:postfix][:smtp_sasl_password_maps] => 'hash:/etc/postfix/smtp_sasl_passwords'
    node[:postfix][:smtp_sasl_passwords][0][:password] => 'secret'
    node[:postfix][:smtp_sasl_passwords][0][:remote] => '[smtp.example.com]'
    node[:postfix][:smtp_sasl_passwords][0][:username] => 'secret')
end


postfix[:sasl_packages].each do |pkg|
    package pkg do
        action :install
    end
end


pw_file = postfix[:smtp_sasl_password_maps].sub('hash:', '')

postfix_map pw_file do
    template_source 'sasl_passwd.erb'
end
