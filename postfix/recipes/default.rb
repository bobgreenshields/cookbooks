package "postfix" do
	action :install
end

execute "hash_vmaps" do
	command "postmap /etc/postfix/vmaps"
	action :nothing
end

template "/etc/postfix/vmaps" do
	source "vmaps.erb"
	mode "0644"
	owner "root"
	group "root"
	variables ({
		:domains => node[:postfix][:domains]
	})
	notifies :run, "execute[hash_vmaps]", :immediately
end

template "/etc/postfix/vhosts" do
	source "vhosts.erb"
	mode "0644"
	owner "root"
	group "root"
	variables ({
		:domains => node[:postfix][:domains]
	})
end
