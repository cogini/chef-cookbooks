use_inline_resources


def whyrun_supported?
    true
end


def role_exists?(role_name)

    command_string = <<-EOS
        psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='#{role_name}'" |
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


action :create do

    unless role_exists?(new_resource.name)

        # TODO HXP: sync options instead of just setting when creating
        command = "psql postgres -tAc 'CREATE ROLE #{new_resource.name} #{new_resource.options.join(' ')}'"

        execute command do
            user 'postgres'
            new_resource.updated_by_last_action(true)
        end
    end
end
