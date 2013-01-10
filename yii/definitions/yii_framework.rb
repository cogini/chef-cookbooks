class Chef::Recipe
    include YiiLibrary
end


define :yii_framework do

    yii_version = params[:name]
    yii_path = params[:path] || yii_default_path(yii_version)

    directory File.dirname(yii_path) do
        action :create
        recursive true
    end

    bash 'install-yii' do
        code <<-EOH
            [[ -d #{yii_path} ]] || git clone https://github.com/yiisoft/yii.git #{yii_path}
            cd #{yii_path}
            git fetch
            git checkout #{yii_version}
        EOH
    end
end
