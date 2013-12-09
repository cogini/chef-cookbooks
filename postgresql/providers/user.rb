def whyrun_supported?
    true
end


use_inline_resources


action :create do

    unless user_exists?(new_resource.name)

        command = "createuser --no-superuser --no-createdb --no-createrole #{new_resource.name}"

        execute command do
            user 'postgres'
            new_resource.updated_by_last_action(true)
        end

        set_password(new_resource.name, new_resource.password)
        set_connection_limit(new_resource.name, new_resource.connection_limit)
    end
end


def user_exists?(name)

    command_string = <<-EOS
        psql postgres -tAc "SELECT 1 FROM pg_user WHERE usename='#{name}'" |
        grep -q 1
    EOS
    command = Mixlib::ShellOut.new(command_string, :user => 'postgres')
    command.run_command

    begin
        command.error!
        true
    rescue
        false
    end
end


def set_password(username, password)
    bash "set password for #{username}" do
        user 'postgres'
        code <<-EOH
            psql -c "ALTER ROLE #{username} ENCRYPTED PASSWORD '#{password}';"
        EOH
        only_if { password }
    end
end


def set_connection_limit(username, connection_limit)
    bash "set connection limit for #{username}" do
        user 'postgres'
        code <<-EOH
            psql -c "ALTER ROLE #{username} CONNECTION LIMIT #{connection_limit};"
        EOH
        only_if { connection_limit }
    end
end
