case node[:platform]
when 'ubuntu'
    package 'php5-xsl' do
        action :install
    end
else
    raise NotImplementedError
end
