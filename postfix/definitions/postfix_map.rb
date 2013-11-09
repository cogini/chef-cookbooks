define :postfix_map do

    map_file = params[:name]

    execute "postmap #{map_file}" do
        action :nothing
    end

    template map_file do
        mode '400'
        notifies :run, resources(:execute => "postmap #{map_file}"), :immediately
        notifies :restart, resources(:service => 'postfix')
    end
end
