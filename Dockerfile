# CUDA 11.6.0を基にしたUbuntu 20.04イメージを使用
FROM nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu22.04

# 非対話モードを設定し、タイムゾーンを設定
ENV DEBIAN_FRONTEND=noninteractive

COPY ./requirements.txt /tmp

# システムのパッケージリストを更新
RUN apt-get update

# software-properties-commonパッケージをインストール
RUN apt-get install -y software-properties-common

# deadsnakes/ppaリポジトリをシステムに追加
RUN add-apt-repository ppa:deadsnakes/ppa

# システムのパッケージリストを再度更新
RUN apt-get update

# Python 3.9と関連パッケージをインストール
RUN apt-get install -y python3.9 python3.9-distutils python3.9-dev

# python3の代わりにpython3.9を使用するように設定
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

# pythonの代わりにpython3.9を使用するように設定
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1


# pipのインストールとアップグレード
RUN apt-get install -y wget \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && rm get-pip.py

RUN pip install -r /tmp/requirements.txt

# 作業ディレクトリの設定
WORKDIR /work

