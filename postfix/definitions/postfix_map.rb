define :postfix_map, :template_source => nil do

    map_file = params[:name]

    execute "postmap #{map_file}" do
        action :nothing
    end

    template map_file do
        mode '400'
        source params[:template_source]
        notifies :run, "execute[postmap #{map_file}]", :immediately
        notifies :restart, 'service[postfix]'
    end
end
