
package 'postgrey'

template '/etc/default/postgrey' do
    source 'postgrey.erb'
    mode 0644
    notifies :restart, "service[postfix]"
end
