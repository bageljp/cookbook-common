#
# Cookbook Name:: common
# Recipe:: default
#
# Copyright 2013, bageljp
#
# All rights reserved - Do Not Redistribute
#

%w(
  /usr/local/work/script
  /usr/local/workconf
  /usr/local/work/tmp
  /usr/local/work/backup
  /usr/local/work/flg
).each do |d|
  directory d do
    owner "work"
    group "work"
    mode 00755
    recursive true
    action :create
  end
end

# キャッシュディレクトリが777じゃないとgit cloneするときにPermission deniedが出る
directory "/tmp/chef-solo" do
  mode 00777
end

