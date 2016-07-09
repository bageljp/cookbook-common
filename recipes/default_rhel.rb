#
# Cookbook Name:: common
# Recipe:: default_rhel
#
# Copyright 2013, bageljp
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
#====================================================================
# CentOS
#====================================================================
when "redhat","centos"
  include_recipe "yum-epel::default"
#====================================================================
# AmazonLinux
#====================================================================
when "amazon"
  %w(
    netperf
  ).each do |pkg|
    package pkg do
      options "--enablerepo=epel"
      action :install
    end
  end

  %w(
    /opt/aws/credentials.txt
    /opt/aws/aws.config
    /etc/profile.d/aws-apitools-custom.sh
  ).each do |t|
    template t do
      owner "root"
      group "root"
      mode 00644
    end
  end
end

case node['platform']
#====================================================================
# Shared
#====================================================================
when "redhat","centos","amazon"
  bash "yum groupinstall Development tools" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development tools" -y
    EOC
    not_if "yum grouplist 'Development tools' | grep -qi ^'Installed Groups:'"
  end

  bash "yum groupinstall Development Libraries" do
    user "root"
    group "root"
    code <<-EOC
      yum groupinstall "Development Libraries" -y
    EOC
    not_if "yum grouplist 'Development Libraries' | grep -qi ^'Installed Groups:'"
  end

  %w(
    yum-utils
    vim-minimal
    vim-common
    vim-enhanced
    sysstat
    tmux
    pssh
    telnet
    nc
    patch
    make
    subversion
    git
    mailx
    man
    dstat
    iotop
    iftop
    ifstatus
    iptraf
    nethogs
    hdparm
    hping3
    fio
    mosh
    jq
    postfix
    socat
    iperf
    tree
    tcpdump
    perf
  ).each do |pkg|
    package pkg do
      options "--enablerepo=epel"
      action :install
    end
  end

  if node['platform'] != "redhat"
    package "postfix-perl-scripts"
  end

  %w(
    atd
    mdmonitor
    lvm2-monitor
    iptables
    ip6tables
  ).each do |svc_off|
    service svc_off do
      action :disable
    end
  end

  link "/etc/localtime" do
    to "/usr/share/zoneinfo/#{node['common']['timezone']}"
  end

  %w(
    /etc/logrotate.d/syslog
    /etc/sysconfig/clock
    /etc/sysconfig/i18n
    /etc/sysconfig/network
    /etc/security/limits.conf
  ).each do |t|
    template t do
      owner "root"
      group "root"
      mode 00644
    end
  end

  template "/etc/profile.d/env.sh" do
    owner "root"
    group "root"
    mode 00644
    case node.chef_environment
    when "production", "staging", "development", "local"
      source "env_" + node.chef_environment + ".sh.erb"
    end
  end

  template "/etc/hosts" do
    owner "root"
    group "root"
    mode 00644
  end
end
