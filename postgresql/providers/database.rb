def whyrun_supported?
    true
end


use_inline_resources


action :create do

    unless db_exists?(new_resource.name)

        command = "createdb \
            --encoding UTF8 \
            --locale=en_US.UTF-8 \
            --template template0 \
            --owner #{new_resource.owner} \
            #{new_resource.name}"

        execute command do
            user 'postgres'
            new_resource.updated_by_last_action(true)
        end
    end
end


def db_exists?(name)

    command_string = <<-EOS
        psql postgres -tAc "SELECT 1 FROM pg_catalog.pg_database WHERE datname = '#{name}'" |
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
