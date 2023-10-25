# CUDA 11.6.0を基にしたUbuntu 20.04イメージを使用
FROM nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu22.04

# 非対話モードを設定し、タイムゾーンを設定
ENV DEBIAN_FRONTEND=noninteractive

# システムパッケージの更新と必要なパッケージのインストール
RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y python3.9 python3.9-distutils python3.9-dev \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1

# pipのインストールとアップグレード
RUN apt-get install -y wget \
    && wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && rm get-pip.py

# PyTorchとその関連パッケージのインストール
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# その他必要なPythonライブラリのインストール
RUN pip install matplotlib numpy pandas scikit-learn

# Jupyter Notebookのインストール
RUN pip install notebook

# Jupyter Notebookの設定（オプション）
RUN jupyter notebook --generate-config --allow-root && \
    echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.password = ''" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py


# 作業ディレクトリの設定
WORKDIR /work

# Jupyter Notebookの起動
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
