include_recipe 'redisio::default'

package 'redis-server' do
  action :install
end
