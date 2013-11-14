version = node[:libav][:version]
arch = node[:kernel][:machine] =~ /x86_64/ ? '64bit' : '32bit'
package_from_url "http://packages.cogini.com/libav-#{version}-#{arch}.deb"
