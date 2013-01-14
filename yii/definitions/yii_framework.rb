class Chef::Recipe
    include YiiLibrary
end


define :yii_framework do

    version = params[:name]
    path = params[:path] || yii_default_path(version)
    symlink = params[:symlink]

    directory File.dirname(path) do
        action :create
        recursive true
    end

    bash 'install-yii' do
        code <<-EOH
            [[ -d #{path} ]] || git clone https://github.com/yiisoft/yii.git #{path}
            cd #{path}
            git fetch
            git checkout #{version}
        EOH
    end

    link symlink do
        to path
        only_if { symlink }
    end
end
