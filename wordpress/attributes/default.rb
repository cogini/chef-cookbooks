#
# Author:: Barry Steinglass (<barry@opscode.com>)
# Cookbook Name:: wordpress
# Attributes:: wordpress
#
# Copyright 2009-2010, Opscode, Inc.
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

# General settings
default['wordpress']['version'] = "3.1.2"
default['wordpress']['checksum'] = "9cad01ac46611d885ffa5d55636c240cda17462e5ba4c31d79b005f35d35af27"
default['wordpress']['dir'] = "/var/www/wordpress"
default['wordpress']['db']['database'] = "wordpressdb"
default['wordpress']['db']['user'] = "wordpressuser"
