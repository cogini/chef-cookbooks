define :git_clone, :destination => nil, :version => nil do

    url = params[:name]
    destination = params[:destination]
    user = params.has_key?(:user) ? params[:user] : 'root'

    execute "git clone #{url} #{destination}" do
        user user
        not_if { File.directory?(File.join(destination, '.git')) }
    end

    if params[:version]
        bash "Checking out #{version} in #{destination}" do
            user user
            code <<-EOH
                cd #{destination}
                git fetch
                git checkout -f #{version}
            EOH
        end
    end

end
