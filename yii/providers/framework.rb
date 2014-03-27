use_inline_resources

action :create do

    run_context.include_recipe 'git'

    version = new_resource.name
    path = new_resource.path || "/opt/yii-#{version}"
    symlink = new_resource.symlink

    directory ::File::dirname(path) do
        action :create
        recursive true
    end

    git "Clone yii #{version}" do
        repository "https://github.com/yiisoft/yii.git"
        destination path
        reference version
    end

    if symlink then

        # make sure path to symlink exists
        directory ::File::dirname(symlink) do
            action :create
            recursive true
        end

        link symlink do
            to path
        end
    end
end
