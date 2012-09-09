pkg = value_for_platform({
    'ubuntu' => {
        'default' => 'php5-xmlrpc',
    },
    ['centos', 'amazon'] => {
        'default' => 'php-xmlrpc',
    },
})

package pkg do
  action :install
end
