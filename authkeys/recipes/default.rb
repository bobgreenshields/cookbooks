template "~/.ssh/authorized_keys" do
  source "authorized_keys.erb"
  mode
  owner "root"
  group "root"
  variables(
    :auth_keys => node[:auth_keys]
  )
end
