
# 環境の立ち上げについてのReadMe（日本語）

## Dockerイメージのビルド
1. まず、`Dockerfile`が配置されているディレクトリに移動してください。
2. 次のコマンドを実行して、Dockerイメージをビルドします。

   ```bash
   docker build . -t my-jupyter
   ```
   
   - このコマンドは、現在のディレクトリ（`.`）の`Dockerfile`を基にして、`my-jupyter`という名前のDockerイメージを作成します。

## Dockerコンテナの実行
1. Dockerイメージがビルドされたら、次のコマンドを実行してコンテナを起動します。

   ```bash
   docker run -it --rm --gpus all -v .:/work -p 8888:8888 my-jupyter sh -c "jupyter-lab --allow-root --ip=0.0.0.0"
   ```

   - `-it`：コンテナが対話モードで実行されるようにします。
   - `--rm`：コンテナの実行が終了したら自動的に削除されるようにします。
   - `--gpus all`：ホストマシンのすべてのGPUをコンテナに利用可能にします。
   - `-v .:/work`：ホストマシンの現在のディレクトリを、コンテナの`/work`ディレクトリにマウントします。
   - `-p 8888:8888`：ホストマシンの8888ポートを、コンテナの8888ポートにフォワードします。
   - `sh -c "jupyter-lab --allow-root --ip=0.0.0.0"`：コンテナ内でJupyter Labを起動するコマンドです。

2. コンテナが正常に起動すると、ブラウザで`http://localhost:8888`にアクセスしてJupyter Labを使用できます。

## Dockerfileの詳細
- `FROM nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu22.04`：CUDA 11.8.0を基にしたUbuntu 22.04のイメージを使用します。
- タイムゾーンは非対話モードで設定されます。
- 必要なPythonパッケージは、`requirements.txt`からインストールされます。
- Python 3.9がインストールされ、デフォルトのPythonバージョンとして設定されます。
- 作業ディレクトリは`/work`に設定されます。
