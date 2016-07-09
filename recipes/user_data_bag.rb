#
# Cookbook Name:: common
# Recipe:: user
#
# Copyright 2013, bageljp
#
# All rights reserved - Do Not Redistribute
#

data_ids = data_bag('users')
data_ids.each do |id|
  #item = data_bag_item('users', id)
  item = Chef::EncryptedDataBagItem.load('users', id)

  item['groups'].each do |g|
    group g['name'] do
      gid g['gid']
      action :create
    end
  end

  item['users'].each do |u|
    user u['name'] do
      uid u['uid']
      gid u['gid']
      shell u['shell']
      supports :manage_home => true, non_unique => false
      password nil
    end

    sudo u['name'] do
      user u['name']
      nopasswd true
    end

    directory "#{u['home']}/.ssh" do
      owner u['uid']
      group u['gid']
      mode 00700
    end

    file "#{u['home']}/.ssh/authorized_keys" do
      owner u['uid']
      group u['gid']
      mode 00600
      content u['ssh_keys'].join()
    end

    template "/etc/security/limits.d/99-#{u['name']}.conf" do
      owner "root"
      group "root"
      mode 00644
      source "limits_user.conf.erb"
      variables({
        :user => u['name']
      })
    end
  end
end

