package 'postfix' do
  action :install
end

service 'postfix' do
  supports :status => true, :restart => true, :reload => true
  action :enable
end
