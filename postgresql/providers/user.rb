use_inline_resources


def whyrun_supported?
    true
end


def user_exists?(username)

    command_string = <<-EOS
        psql postgres -tAc "SELECT 1 FROM pg_user WHERE usename='#{username}'" |
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


def password_correct?(username, password)

    sql = "SELECT 1 FROM pg_shadow
        WHERE usename = '#{username}'
        AND passwd = CONCAT('md5', MD5('#{password}#{username}'))"
    command_string = <<-EOS
        psql postgres -tAc "#{sql}" | grep -q 1
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


def connection_limit_correct?(username, connection_limit)

    sql = "SELECT 1 FROM pg_authid
        WHERE rolname = '#{username}'
        AND rolconnlimit = #{connection_limit}"
    command_string = <<-EOS
        psql postgres -tAc "#{sql}" | grep -q 1
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

    execute "set password for #{username}" do
        user 'postgres'
        command <<-EOC
psql <<EOP
    ALTER ROLE "#{username}" ENCRYPTED PASSWORD '#{password}'
EOP
        EOC
        not_if { password_correct?(username, password) }
        new_resource.updated_by_last_action(true)
    end
end


def set_connection_limit(username, connection_limit)
    execute "set connection limit for #{username}" do
        user 'postgres'
        command <<-EOH
psql <<EOF
    ALTER ROLE "#{username}" CONNECTION LIMIT #{connlimit};
EOF
        EOH
        not_if { connection_limit_correct?(username, connection_limit) }
    end
end


action :create do

    unless user_exists?(new_resource.name)

        command = "createuser --no-superuser --no-createdb --no-createrole #{new_resource.name}"

        execute command do
            user 'postgres'
            new_resource.updated_by_last_action(true)
        end
    end

    if new_resource.password
        set_password(new_resource.name, new_resource.password)
    end

    if new_resource.connection_limit
        set_connection_limit(new_resource.name, new_resource.connection_limit)
    end
end
