#
# Cookbook Name:: ffmpeg
# Recipe:: default
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

include_recipe "fpm"
include_recipe "yum::atrpms"

ffmpeg_version = node["ffmpeg"]["version"]
chef_cache = Chef::Config[:file_cache_path]


node[:ffmpeg][:dependencies][:atrpms].each do |pkg|
    package pkg do
        action :install
        options '--enablerepo=atrpms'
    end
end


node[:ffmpeg][:dependencies][:epel].each do |pkg|
    package pkg do
        action :install
        options '--enablerepo=epel'
    end
end


pkg_file = value_for_platform(
    %w{redhat centos} => {
        "default" => "#{chef_cache}/ffmpeg-#{ffmpeg_version}.rpm"
    },
    # Ubuntu
    "default" => "#{chef_cache}/ffmpeg-#{ffmpeg_version}.deb"
)

pkg_type = pkg_file[-3..-1]


unless File.exists?(pkg_file)
    remote_file "#{chef_cache}/ffmpeg-#{ffmpeg_version}.tar.gz" do
        source "http://ffmpeg.org/releases/ffmpeg-#{ffmpeg_version}.tar.bz2"
        action :create_if_missing
    end

    bash "build_ffmpeg" do
        cwd chef_cache
        code <<-EOH
            path_extras="/var/lib/gems/1.8/bin"
            for extra in $(echo $path_extras)
                do
                test -d $extra && test ":$PATH:" != "*:$extra:*" && PATH="$extra:$PATH"
            done
            tar xvf ffmpeg-#{ffmpeg_version}.tar.gz
            cd ffmpeg-#{ffmpeg_version}
            # Vorbis and AAC is native
            # Built in Vorbis is broken
            ./configure \
                --enable-gpl \
                --enable-nonfree \
                --enable-libtheora \
                --enable-libx264 \
                --enable-libfaac \
                --enable-libvorbis \
                --disable-encoder=vorbis
            make
            make install DESTDIR=./install
            fpm -s dir -t #{pkg_type} -n ffmpeg -v #{ffmpeg_version} -p #{pkg_file} -C install .
        EOH
    end
end

package "ffmpeg" do
    action :install
    source pkg_file
    provider node[:fpm][:provider]
end
