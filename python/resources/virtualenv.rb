#
# Author:: Seth Chisamore <schisamo@opscode.com>
# Cookbook Name:: python
# Resource:: virtualenv
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
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


default_interpreter = 'python2.6'

case node[:platform]
when 'ubuntu'
    if node[:platform_version].to_f >= 12.04
        default_interpreter = 'python2.7'
    end
end


actions :create, :delete

attribute :path, :kind_of => String, :name_attribute => true
attribute :interpreter, :default => default_interpreter
attribute :owner, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
