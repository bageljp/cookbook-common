define :user_group_setup do

  user = "#{params[:name]}"
  uid = "#{params[:uid]}"
  group = "#{params[:group]}"
  gid = "#{params[:gid]}"
  sudo = params[:sudo]
  authorized_key = "#{params[:authorized_key]}"

  group "#{group}" do
    gid gid
    append true
  end

  user "#{user}" do
    supports :manage_home => true
    uid uid
    gid "#{group}"
    home "/home/#{user}"
    shell "/bin/bash"
    password nil
  end

  directory "/home/#{user}/.ssh" do
    owner "#{user}"
    group "#{group}"
    mode 00700
  end

  #cookbook_file "/home/#{user}/.ssh/id_rsa" do
  #  owner "#{user}"
  #  group "#{group}"
  #  mode 00600
  #end

  template "/home/#{user}/.ssh/authorized_keys" do
    owner "#{user}"
    group "#{group}"
    mode 00600
    variables({
      :authorized_key => "#{authorized_key}"
    })
  end

  template "/home/#{user}/.ssh/config" do
    owner "#{user}"
    group "#{group}"
    mode 00600
    Chef::Config[:cookbook_path].each{|elem|
      if File.exists?(File.join(elem, "/common/templates/default"))
        conf_dir = File.join(elem, "/common/templates/default")
        Dir.chdir conf_dir
        confs = Dir::glob("**/*")

        confs.each do |t|
          if File::ftype("#{conf_dir}/#{t}") == "file"
            if File.exist?(conf_dir + "/user_ssh_config_" + "#{user}" + "_" + node.chef_environment + ".erb")
              source "user_ssh_config_" + "#{user}" + "_" + node.chef_environment + ".erb"
            elsif File.exist?(conf_dir + "/user_ssh_config_" + "#{user}" + ".erb")
              source "user_ssh_config_" + "#{user}" + ".erb"
            elsif File.exist?(conf_dir + "/user_ssh_config_" + node.chef_environment + ".erb")
              source "user_ssh_config_" + node.chef_environment + ".erb"
            else
              source "user_ssh_config.erb"
            end
          end
        end
      end
    }
    variables({
      :user => "#{user}"
    })
  end

  if sudo == true
    template "/etc/sudoers.d/#{user}" do
      owner "root"
      group "root"
      mode 00644
      source "sudo_user.conf.erb"
      variables({
        :user => "#{user}"
      })
    end
  end

  template "/etc/security/limits.d/99-#{user}.conf" do
    owner "root"
    group "root"
    mode 00644
    source "limits_user.conf.erb"
    variables({
      :user => "#{user}"
    })
  end

end
