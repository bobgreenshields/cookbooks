
auth_keys = node[:auth_keys]
auth_keys.each do |key_data|
	template "/home#{key_data["user"]}/.ssh/authorized_keys" do
	  source "authorized_keys.erb"
	  mode "0644"
	  owner key_data["user"]
	  group key_data["user"]
	  variables(
	    :keystrings => key_data["keys"]
          )
	end
end
