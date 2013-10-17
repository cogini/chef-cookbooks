define :git_clone, :destination => nil, :version => nil do

    url = params[:name]
    destination = params[:destination]
    user = if params[:user]
              params[:user]
           else
              "root"
           end

    execute "git clone #{url} #{destination}" do
        user user
        not_if { File.exists?(destination) }
    end

    if params[:version]
        bash "Checkout #{params[:version]}" do
            user user
            code <<-EOH
                cd #{destination}
                git fetch
                git checkout -f #{version}
            EOH
        end
    end

end
