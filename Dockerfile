ARG NEXTCLOUD_VERSION=29.0.6-fpm-alpine
FROM nextcloud:${NEXTCLOUD_VERSION}

RUN set -ex; \
    \
    apk add --no-cache \
        ffmpeg \
        imagemagick \
        procps \
        samba-client \
        #supervisor \
        libreoffice \
        libcudnn8=8.6.0.163-1+cuda11.8
#        python3 \
#        py3-pip \
#        gcc \
#        g++ \
#        make \
#        linux-headers \
#        wget        


# Copy CUDA installer
#COPY cuda_12.4.0_550.54.14_linux.run /tmp/

# Install CUDA Toolkit 12.4
#RUN chmod +x /tmp/cuda_12.4.0_550.54.14_linux.run \
#    && /tmp/cuda_12.4.0_550.54.14_linux.run --toolkit --silent \
#    && rm /tmp/cuda_12.4.0_550.54.14_linux.run

#ENV PATH=/usr/local/cuda/bin:${PATH}
#ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# Install cuDNN
#COPY cudnn-linux-x86_64-9.4.0.58_cuda12-archive.tar.xz /tmp/
#RUN tar -xf /tmp/cudnn-linux-x86_64-9.4.0.58_cuda12-archive.tar.xz -C /usr/local \
#    && rm /tmp/cudnn-linux-x86_64-9.4.0.58_cuda12-archive.tar.xz


## Install PyTorch with CUDA support
#RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

RUN set -ex; \
    \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        imap-dev \
        krb5-dev \
        openssl-dev \
        samba-dev \
        bzip2-dev \
    ; \
    \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install \
        bz2 \
        imap \
    ; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --virtual .nextcloud-phpext-rundeps $runDeps; \
    apk del .build-deps

#RUN nvcc --version && \
#    python3 -c "import torch; print(torch.cuda.is_available())"
    
#RUN mkdir -p \
#    /var/log/supervisord \
#    /var/run/supervisord \
#;

#COPY supervisord.conf /

#ENV NEXTCLOUD_UPDATE=1

#CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
