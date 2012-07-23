default[:ffmpeg][:version] = "0.10.3"
set[:ffmpeg][:dependencies][:atrpms] = %w{
    faac-devel
    libtheora-devel
    libvorbis-devel
    x264-devel
}
set[:ffmpeg][:dependencies][:epel] = %w{
    yasm
}
