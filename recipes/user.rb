#
# Cookbook Name:: common
# Recipe:: user
#
# Copyright 2013, bageljp
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
when "redhat","centos","amazon"
  users = node['common']['users'].each
  uids = node['common']['uids'].each
  groups = node['common']['groups'].each
  gids = node['common']['gids'].each
  sudoers = node['common']['sudoers'].each
  authorized_keys = node['common']['ssh']['authorized_keys'].each
  node['common']['users'].each do |user|
    user_group_setup "#{user}" do
      uid uids.next
      group groups.next
      gid gids.next
      sudo sudoers.next
      authorized_key authorized_keys.next
    end
  end
end
