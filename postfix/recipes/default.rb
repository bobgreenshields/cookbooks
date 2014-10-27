package "postfix" do
	action :install
end

execute "hash_vmaps" do
	command "postmap /etc/postfix/vmaps"
	action :nothing
end

service "postfix" do
	supports :restart => true, :start => true, :stop => true
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
	notifies :restart, "service[postfix]"
end

template "/etc/postfix/vhosts" do
	source "vhosts.erb"
	mode "0644"
	owner "root"
	group "root"
	variables ({
		:domains => node[:postfix][:domains]
	})
	notifies :restart, "service[postfix]"
end

execute "hash_saslpasswd" do
	command "postmap /etc/postfix/saslpasswd"
	action :nothing
end

smtp_auth_reqd = node[:postfix].has_key?("smtp_login")

if smtp_auth_reqd
	template "/etc/postfix/saslpasswd" do
		source "saslpasswd.erb"
		mode "0600"
		owner "root"
		group "root"
		variables ({
			:server => node[:postfix][:smtp_server],
			:login => node[:postfix][:smtp_login],
			:password => node[:postfix][:smtp_password]
		})
		notifies :run, "execute[hash_saslpasswd]", :immediately
		notifies :restart, "service[postfix]"
	end
end

networks_array = node[:postfix][:networks_base] + Array(node[:postfix][:networks])
networks = networks_array.join(' ')
#networks = (node[:postfix][:networks_base] << node[:postfix][:networks]).join(' ')
#networks = node[:postfix][:networks_base].join(' ')
#networks = "hello"

template "/etc/postfix/main.cf" do
	source "main.cf.erb"
	mode "0644"
	owner "root"
	group "root"
	variables ({
		:my_hostname => node[:postfix][:my_hostname],
		:my_domain => node[:postfix][:my_domain],
		:smtp_server => node[:postfix][:smtp_server],
		:smtp_port => node[:postfix][:smtp_port],
		:smtp_auth_reqd => smtp_auth_reqd,
		:networks => networks,
		:mail_folder => node[:postfix][:mail_folder],
		:virtual_uid => node[:postfix][:mail_uid],
		:virtual_gid => node[:postfix][:mail_gid]
	})
	notifies :restart, "service[postfix]"
end

if node[:postfix].has_key?("required_mount")
	req_mnt = node[:postfix][:required_mount]
	unless Regexp.new(req_mnt).match(`mount`)
		raise Chef::Exceptions::FileNotFound,
			"Could not build dir structure as missing mount #{req_mnt}"
	end
end

mail_root = node[:postfix][:mail_folder]
mail_owner = node[:postfix][:mail_owner]
mail_group = node[:postfix][:mail_group]
directory "#{mail_root}" do
	owner mail_owner
	group mail_group
	mode "0770"
	action :create
	recursive true
end

node[:postfix][:domains].each do |domain, dom_data|
	directory "#{mail_root}/#{domain}" do
		owner mail_owner
		group mail_group
		mode "0770"
		action :create
	end

	dom_data["users"].each do |user|
		umf = user["mail_folder"]
		directory "#{mail_root}/#{domain}/#{umf}" do
			owner mail_owner
			group mail_group
			mode "0770"
			action :create
		end # directory

		node[:postfix][:mail_folders].each do |f|
			directory "#{mail_root}/#{domain}/#{umf}/#{f}" do
				owner mail_owner
				group mail_group
				recursive true
				mode "0770"
				action :create
			end # directory
		end # folders.each
	end # dom_data["users"]

end # node[:postfix][:domains]
