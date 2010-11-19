service "ssh" do
	supports :restart => true, :reload => true, :status => true
	action :nothing
end

auth_keys = node[:auth_keys]

auth_keys.each do |key_data|
  kuser = key_data["user"]

  Chef::Log.info("Key user is #{kuser}")
  directory "/home/#{kuser}/.ssh" do
    owner kuser
    group kuser
    mode "0700"
    action :create
  end

  Chef::Log.info("#{kuser} has #{key_data["keys"].length} keys")

  template "/home/#{kuser}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    mode "0644"
    owner kuser
    group kuser
    variables(
      :keystrings => key_data["keys"]
    )
    notifies :reload, "service[ssh]", :immediately
  end
end
