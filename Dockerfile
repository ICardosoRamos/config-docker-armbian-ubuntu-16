

FROM arm32v7/ubuntu:16.04

# Seta variáveis de ambiente
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHON_VERSION 3.8.20


# Instala dependências
RUN apt update && apt install -y \
    wget \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libdb5.3-dev \
    libbz2-dev \
    libexpat1-dev \
    liblzma-dev \
    libffi-dev \
    iputils-ping \
    libjpeg-dev && \
    apt autoremove -y && apt clean && \
    rm -rf /var/lib/apt/lists/*


# Compilar e instalar Python com suporte a shared lib
RUN cd /usr/src && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations --enable-shared && \
    make -j$(nproc) && \
    make altinstall && \
    echo "/usr/local/lib" > /etc/ld.so.conf.d/python3.8.conf && \
    ldconfig

RUN cd /usr/src && \
    rm -rf Python-${PYTHON_VERSION} Python-${PYTHON_VERSION}.tgz


ENV LD_LIBRARY_PATH=/usr/local/lib


# Define a pasta de trabalho
WORKDIR /app


# Copia o requirements.txt
COPY requirements.txt ./


# Instala pip e pyinstaller
RUN python3.8 -m ensurepip
RUN python3.8 -m pip install --upgrade pip
RUN python3.8 -m pip install pyinstaller
RUN python3.8 -m pip install -r requirements.txt --extra-index http://ferramentas.cloudpark.com.br/pypi --trusted-host ferramentas.cloudpark.com.br


# Comando para compilar
CMD ["echo", "Instalação requirements.txt concluída!"]