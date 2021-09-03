# execute through "docker build -t ffmpeg:<your-version-id> ."
#
# if building ffmpeg to be used in a docker environment, something like this:
#
#	$ docker build -t ffmpeg:ffmpeg4.4-alpine3.7-turing0.1 .
#
# so that people know in to which environment it's to be used.

# FROM <here> must match whatever environment in which ffmpeg will be used.
FROM alpine:3.13 AS ffmpeg
MAINTAINER eric@turingvideo.net

# artifacts you may want to copy out from this docker container:
#
#  bin/*                        (this is where ffmpeg lives)
#  include/lib*/*.h             (headers for linking your custom binary to libraries)
#  lib/lib*.[a|so]              (link your custom binary to these libraries)
#  lib/pkgconfig/lib*.pc        (files that pkg-config uses)
#  share/ffmpeg/*.preset        (example settings to use as guides)
#  share/ffmpeg/examples/*.c    (example custom binaries to use as guides)
#
# what I do is tar/gzip all of them and make a package:
#
#       $ mv dist ffmpeg4.4-alpine3.13-turing0.1
# 	$ tar cvzf ffmpeg4.4-alpine3.13-turing0.1.tar.gz ./ffmpeg4.4-alpine3.13-turing0.1
#
# then scp it out and push it to github.  an automated solution would be much
# better, if you can think of one.

COPY . .

# openssh-client is needed only so we can scp files out of the container,
# and later upload to github.
RUN apk add openssh-client build-base nasm yasm openssl-dev && \
make distclean || echo "\"make distclean\" failed and this is ok" && \
./configure \
	--prefix=dist \
	--disable-debug \
	--disable-doc \
	--disable-ffplay \
	--disable-ffprobe \
	--enable-shared \
	--enable-pthreads \
	--enable-small \
	--enable-version3 \
	--extra-cflags="" \
	--extra-ldflags="" \
	--enable-gpl \
	--enable-nonfree \
	--enable-openssl \
	--disable-libx264 \
	--disable-libx265 \
	--disable-libopencore-amrnb \
	--disable-libopencore-amrwb \
	--disable-libfreetype \
	--disable-libvidstab \
	--disable-libmp3lame \
	--disable-libopenjpeg \
	--disable-libopus \
	--disable-libtheora \
	--disable-libvorbis \
	--disable-libvpx \
	--disable-libxvid \
	--disable-libfdk_aac \
	--disable-libkvazaar \
	--disable-libaom && \
make && \
make install && \
make clean

# access the artifacts:
#
# 	$ docker build -t ffmpeg:<your-version-id> .
# 	$ docker run -i -t <container-hash>

ENTRYPOINT ["/bin/ash"]
