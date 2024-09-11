ARG NEXTCLOUD_VERSION=29.0.6-apache
FROM nextcloud:${NEXTCLOUD_VERSION}


#RUN wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-debian11-11-8-local_11.8.0-520.61.05-1_amd64.deb && \
#    dpkg -i cuda-repo-debian11-11-8-local_11.8.0-520.61.05-1_amd64.deb && \
#    cp /var/cuda-repo-debian11-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/ && \
#    rm cuda-repo-debian11-11-8-local_11.8.0-520.61.05-1_amd64.deb
    
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        ghostscript \
        libmagickcore-6.q16-6-extra \
        procps \
        smbclient \
        libreoffice \    
        wget \
        software-properties-common \
        gnupg \        
        python3 \
        python3-pip \
        python3-dev \
        gcc \           
    ; \
    rm -rf /var/lib/apt/lists/*


# Download and install CUDA
#RUN wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-debian11-11-8-local_11.8.0-520.61.05-1_amd64.deb \
#  && dpkg -i cuda-repo-debian11-11-8-local_11.8.0-520.61.05-1_amd64.deb \
#  && cp /var/cuda-repo-debian11-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/ \
#  && add-apt-repository contrib \
#  && apt-get update \
#  && apt-get -y install cuda 



#RUN wget https://developer.download.nvidia.com/compute/cudnn/9.4.0/local_installers/cudnn-local-repo-debian12-9.4.0_1.0-1_amd64.deb \
#    && dpkg -i cudnn-local-repo-debian12-9.4.0_1.0-1_amd64.deb \
#    && cp /var/cuda-repo-debian12-9-4-local/cudnn-*-keyring.gpg /usr/share/keyrings/ 
  

RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        libc-client-dev \
        libkrb5-dev \
        libsmbclient-dev \
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
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

# Install TensorFlow
RUN pip3 install --upgrade pip --break-system-packages   
RUN pip3 install --no-cache-dir tensorflow[and-cuda] --break-system-packages   
#                    libcudnn8-dev_8.6.0.163-1+cuda11.8_amd64.deb

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb \
    && dpkg -i cuda-keyring_1.1-1_all.deb \
    && apt-get update

RUN apt-get install libcudnn8=8.6.0.163-1+cuda11.8
# Set CUDA environment variables
#ENV PATH=/usr/local/cuda/bin:${PATH}
#ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
