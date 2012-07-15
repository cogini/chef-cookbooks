pkg = value_for_platform({
    "ubuntu" => {
        "default" => "php5-intl",
    },
    "amazon" => {
        "default" => "php-intl",
    },
})

package pkg do
  action :install
end
