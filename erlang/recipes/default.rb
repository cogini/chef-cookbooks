include_recipe 'fpm'
include_recipe 'git'

chef_cache = Chef::Config[:file_cache_path]
version = node[:erlang][:version]
source_dir = "#{chef_cache}/erlang-otp"

pkg_file = "#{chef_cache}/erlang-otp-#{version}.deb"
pkg_type = pkg_file[-3..-1]


unless File.exists?(pkg_file)

  bash 'get erlang source' do
    code <<-EOH
      [[ -d #{source_dir} ]] || git clone git://github.com/erlang/otp.git #{source_dir}
      cd #{source_dir}
      git fetch
      git checkout OTP_#{version}
    EOH
  end

  bash 'compile erlang' do
    cwd source_dir
    code <<-EOH
      apt-get build-dep -y erlang
      ./otp_build autoconf
      ./configure
      make
      make install DESTDIR=#{source_dir}/install
      fpm -s dir -t #{pkg_type} -n erlang-otp -v 1 -p #{pkg_file} -C install .
    EOH
  end
end

package 'erlang-otp' do
    action :install
    source pkg_file
    provider node[:fpm][:provider]
end
