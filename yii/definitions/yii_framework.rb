class Chef::Recipe
    include YiiLibrary
end


define :yii_framework do

    include_recipe 'git'

    version = params[:name]
    path = params[:path] || yii_default_path(version)
    symlink = params[:symlink]

    directory File.dirname(path) do
        action :create
        recursive true
    end

    git "Clone yii #{version}" do
        repository "https://github.com/yiisoft/yii.git"
        destination path
        reference version
    end

    link symlink do
        to path
        only_if { symlink }
    end
end
