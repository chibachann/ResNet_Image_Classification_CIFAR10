# Docker環境の説明

## **基本情報**

- **Base Image**: NVIDIA CUDA 11.8.0 開発環境、Ubuntu 22.04ベース
- **目的**: CIFAR-10データセットに対する画像分類タスクの実行
- **使用技術**: PyTorch

## **環境構築**

1. Docker Imageのビルド
    ```bash
    docker build -t image_classification_env .
    ```

2. Docker Containerの起動
    ```bash
    docker run --gpus all -it --rm image_classification_env
    ```

## **インストール済みパッケージ**

- **システムパッケージ**
  - Python 3.9
  - wget
  - その他依存関係

- **Pythonライブラリ**
  - torch, torchvision, torchaudio
  - matplotlib
  - numpy
  - pandas
  - scikit-learn

## **作業ディレクトリ**

- `/work`

## **使用方法**

- Docker Container内の`/work`ディレクトリで作業を行います。
- 必要に応じて追加のPythonライブラリをインストールしてカスタマイズが可能です。

## **注意事項**

- Docker ContainerはGPUを利用する設定になっています。GPUがない環境では`--gpus all`オプションを削除してください。
