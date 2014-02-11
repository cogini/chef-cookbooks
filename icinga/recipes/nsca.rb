unless node[:icinga][:check_external_commands] == 1
    raise 'node[:icinga][:check_external_commands] must be 1.'
end

package 'nsca'
