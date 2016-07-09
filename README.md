What's ?
===============
chef で使用する OS共通設定 の cookbook です。

Usage
-----
cookbook なので berkshelf で取ってきて使いましょう。

* Berksfile
```ruby
source "https://supermarket.chef.io"

cookbook "common", git: "https://github.com/bageljp/cookbook-common.git"
```

```
berks vendor
```

#### Role and Environment attributes

* sample_role.rb
```ruby
override_attributes(
  "common" => {
    "hostname" => "localhost.localdomain",
    "log" => {
      "rotate" => "31"
    },
    "users" => ["work", "guest"],
    "uids" => [501, 1001],
    "groups" => ["work", "guest"],
    "gids" => [501, 1001],
    "sudoers" => [true, false],
    "ssh" => {
      "authorized_keys" => [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCPMa1xHtioJ0r9BJubVLIAJjzc0TgVIRC4/UrJ... workpublick-key",
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzMJatA7Hf+U0SpH+v5CfQlM0TdZvVFg1Kndfj... guest@public-key"
      ]
    }
  }
)
```

Recipes
----------

#### common::default_rhel
RHEL系 (AmazonLinux含む) の共通設定です。
運用で便利なパッケージインストールしたり何時も修正するファイル変更したり。

#### common::default_debian
上記のDebian系。ほとんどメンテしてないので使用には注意。

#### common::user
ユーザ、グループの作成と公開鍵やsudoなんかのユーザ周りの設定。

#### common::user_data_bag
上記のdata_bag版。使い分けはお好みで。

#### common::common
default レシピや他の cookbook に入れるのも気が引ける個人的な設定とかPJ用の設定とか書いてた。

Attributes
----------

多分 Usage のサンプルの記載見ればわかると思います。

Others
----------

data_bag版を使う場合は以下の様なjsonを定義する。

```
knife solo data bag create users work
```

* work.json
```json
{
  "id": "work",
  "groups": [
    {
      "name": "work",
      "gid": 501
    }
  ],
  "users": [
    {
      "name": "work",
      "uid": 501,
      "gid": 501,
      "home": "/home/work",
      "shell": "/bin/bash",
      "ssh_keys": [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCPMa1xHtioJ0r9BJubVLIAJjzc0TgVIRC4/UrJ... work@public-key"
      ]
    }
  ]
}
```
