FROM ubuntu:12.04

RUN sed -ri "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN groupadd -r admin
RUN useradd --create-home --gid admin admin
RUN groupadd -r bae
RUN useradd --create-home --gid bae bae

RUN mkdir -p /home/bae/log
RUN chmod a+rwx /home/bae/log

COPY ./runtime /home/admin/runtime
EXPOSE 8080
VOLUME /home/bae/app

WORKDIR /home/admin/runtime

CMD ["/home/admin/runtime/lighttpd/bin/lighttpd", \
    "-m", "/home/admin/runtime/lighttpd/lib", \
    "-f", "/home/admin/runtime/lighttpd/conf/lighttpd.conf", \
    "-D" \
]

