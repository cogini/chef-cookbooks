case node['platform']
when 'ubuntu'
    package 'php5-imagick' do
        action :install
    end
else
    raise NotImplementedError
end
