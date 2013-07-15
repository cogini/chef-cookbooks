
include_recipe "apt"
include_recipe "git"
include_recipe "fpm"


chef_cache = Chef::Config[:file_cache_path]
version = node[:libav][:version]
source_dir = "#{chef_cache}/libav"

pkg_file = "#{chef_cache}/libav-#{version}.deb"
pkg_type = pkg_file[-3..-1]


unless File.exist?(pkg_file)

    bash "Get libav source" do
        code <<-EOH
            [[ -d #{source_dir} ]] || git clone git://git.libav.org/libav.git #{source_dir}
            cd #{source_dir}
            git fetch
            git checkout #{version}
        EOH
    end

    bash 'Compile libav' do
        cwd source_dir
        code <<-EOH
            apt-get build-dep -y libav
            ./configure
            make
            make install DESTDIR=#{source_dir}/install
            fpm -s dir -t #{pkg_type} -n libav -v 1 -p #{pkg_file} -C install .
        EOH
    end

end


package "libav" do
    action :install
    source pkg_file
    provider node[:fpm][:provider]
end
