```shell
# 実行権限を付与
chmod +x dotfiles/setup.sh
cd ~/dotfiles
./setup.sh # シンボリックリンクを貼る

chmod +x install
./install
```

参考: [ようこそdotfilesの世界へ - Qiita](https://qiita.com/yutakatay/items/c6c7584d9795799ee164)

```shell
pr "title"
```

## Tools

- [Alfred - Productivity App for macOS](https://www.alfredapp.com/)
- [Download RubyMine: Ruby and Rails IDE by JetBrains](https://www.jetbrains.com/ruby/download/#section=mac)
  - Keymap: [RubyMine 設定の エクスポート/インポート 方法 (IntelliJ共通) - Qiita](https://qiita.com/k-waragai/items/2922fe32b898d670393d#how-to-github%E3%81%AB%E7%99%BB%E9%8C%B2%E3%81%97%E5%8B%9D%E6%89%8B%E3%81%ABsync%E3%81%95%E3%81%9B%E3%82%8B)
    ![スクリーンショット 2021-12-06 18 47 21](https://user-images.githubusercontent.com/33926355/144824455-6a4e1f3c-f39d-4bb0-93a9-4daedb76fb87.png)
  - [GitHub | RubyMine](https://pleiades.io/help/ruby/github.html)
  > トークンの repo、gist、および read:org スコープがアカウント権限で有効になっている必要があります（スコープの理解(英語)を参照）。
- [Download Visual Studio Code - Mac, Linux, Windows](https://code.visualstudio.com/download)
- [Best Password Manager for macOS & Safari | 1Password](https://1password.com/downloads/mac/)
- [Google Chrome - Google の高速で安全なブラウザをダウンロード](https://www.google.com/chrome/)
- [BettorTouch Tool](https://folivora.ai/)
- [fikovnik/ShiftIt](https://github.com/fikovnik/ShiftIt/releases)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
  - Settings: [USキーボードで入力ソースを簡単に切り替える](https://zenn.dev/takeucheese/articles/1ee9b7e09c26fd)
- [Homebrew](https://brew.sh/index_ja)
- [Docker Desktop for Mac by Docker | Docker Hub](https://hub.docker.com/editions/community/docker-ce-desktop-mac/)
- [Git Automator [V3 PREVIEW] - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ivangabriele.vscode-git-automator)
- [Download Figma Desktop Apps, Mobile Apps, and Font Installers](https://www.figma.com/downloads/)
- [SSH について - GitHub Docs](https://docs.github.com/ja/github/authenticating-to-github/connecting-to-github-with-ssh/about-ssh)
- [VS Codeでファイル末尾に自動的に改行を挿入する設定 - Qiita](https://qiita.com/norikt/items/83674fadd79a88bf7824)

```shell
# pip: https://pip.pypa.io/en/stable/installing/
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
which pip3
```

## Trouble shooting

`npm install --global`でインストールしたけれど動かないという場合は、下記の手順を実行。

[Resolving EACCES permissions errors when installing packages globally | npm Docs](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally#manually-change-npms-default-directory)

## Ruby, Rails

- [【完全版】MacでRails環境構築する手順の全て - Qiita](https://qiita.com/kodai_0122/items/56168eaec28eb7b1b93b)
  - Bug: [gem install をしようとしたらOperation not permitted がでた。。 | ハックノート](https://hacknote.jp/archives/28037/)
