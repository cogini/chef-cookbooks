include_recipe 'php::fpm'

php_pear "zendopcache" do
  action :install
  preferred_state :beta  # for now there is no "stable" zendopcache package
  zend_extensions ['opcache.so']
  directives(
    :memory_consumption => 128,
    :interned_strings_buffer => 8,
    :max_accelerated_files => 4000,
    :revalidate_freq => 60,
    :fast_shutdown => 1,
    :enable_cli => 1,
  )
end
