default[:ffmpeg][:version] = '0.10.3'
arch = node[:kernel][:machine] =~ /x86_64/ ? '64bit' : '32bit'
default[:ffmpeg][:package_url] = "http://packages.cogini.com/ffmpeg-#{node[:ffmpeg][:version]}-#{arch}.rpm"
