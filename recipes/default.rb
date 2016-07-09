#
# Cookbook Name:: common
# Recipe:: default
#
# Copyright 2013, bageljp
#
# All rights reserved - Do Not Redistribute
#

case node['platform_family']
when "debian"
  include_recipe "common::default_debian"
when "rhel"
  include_recipe "common::default_rhel"
end

