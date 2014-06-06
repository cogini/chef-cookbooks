case node[:platform]
when 'ubuntu'
    package 'php5-json' do
        action :install
    end
else
    raise NotImplementedError
end
