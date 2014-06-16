# Installation steps as instructed at
# https://help.ubuntu.com/community/Mailman

for recipe in ['apache2', 'postfix'] do
    include_recipe recipe
end

user 'mailman' do
    action :create
end

group 'mailman' do
    action :create
    members 'mailman'
end

package 'mailman' do
    action :install
end

web_app 'mailman' do
    cookbook 'mailman'
    template 'mailman.conf.erb'
end

template '/etc/mailman/mm_cfg.py' do
    source 'mm_cfg.py.erb'
end
