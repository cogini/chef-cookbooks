pkg = value_for_platform({
    'ubuntu' => {
        'default' => 'php5-intl',
    },
    ['centos', 'amazon'] => {
        'default' => 'php-intl',
    },
})

package pkg do
  action :install
end
