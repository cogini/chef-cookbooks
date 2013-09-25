case node[:platform]
when 'ubuntu'
    default.tz = 'Etc/UTC'
else
    default.tz = 'UTC'
end

# Path to tzdata directory
default.timezone.tzdata_dir = '/usr/share/zoneinfo'

# Path to file used by kernel for local timezone's data
default.timezone.localtime_path = '/etc/localtime'

# Whether to use a symlink to tzdata (instead of copying).
# Used only in the linux-default recipe.
default.timezone.use_symlink = false
