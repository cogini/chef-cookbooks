#
# Cookbook Name:: cron
# Recipe:: default
#
# Copyright 2010-2013, Opscode, Inc.
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

package 'cron' do
  package_name case node['platform_family']
               when 'rhel', 'fedora'
                 node['platform_version'].to_f >= 6.0 ? 'cronie' : 'vixie-cron'
               end
end

service 'cron' do
  service_name 'crond' if platform_family?('rhel', 'fedora')
  action [:enable, :start]
end

if node[:cron][:users]

  # Remove crontab of users if not listed in node.json
  Dir.foreach('/var/spool/cron/crontabs') do |crontab|
    next if crontab == '.' or crontab == '..'
    if !node[:cron][:users].has_key?(crontab)
      file "/var/spool/cron/crontabs/#{crontab}" do
        action :delete
      end
    end
  end

  node[:cron][:users].each do |user, jobs|
    template "/var/spool/cron/crontabs/#{user}" do
      source 'crond.user.erb'
      mode '600'
      variables(
        :jobs => jobs,
        :user => user
      )
      user user
      group "crontab"
    end
  end
end
