php_pear "zendopcache" do
  action :install
  preferred_state :beta  # for now there is no "stable" zendopcache package
  zend_extensions ['opcache.so']
  directives node[:php][:opcache]
end
