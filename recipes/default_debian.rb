#
# Cookbook Name:: common
# Recipe:: default_debian
#
# Copyright 2013, bageljp
#
# All rights reserved - Do Not Redistribute
#

#====================================================================
# Debian, Ubuntu
#====================================================================
package "tzdata"

bash "modify timezone" do
  user "root"
  group "root"
  code "/usr/sbin/dpkg-reconfigure -f noninteractive tzdata"
  action :nothing
end

template "/etc/timezone" do
  owner "root"
  group "root"
  mode 0644
  notifies :run, "bash[modify timezone]", :immediately
end

%w(vim unzip).each do |pkg|
  package pkg
end

%w(
  /etc/profile.d/env.sh
).each do |t|
  template t do
    owner "root"
    group "root"
    mode 00644
  end
end

