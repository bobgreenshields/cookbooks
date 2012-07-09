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

#networks = [:postfix][:networks_base] << [:postfix][:networks].join(' ')
networks = node[:postfix][:networks_base].join(' ')
#networks = "hello"
if node[:postfix].has_key?("networks_base")
	puts "key has been found"
else
	puts "key has NOT been found"
end
puts "networks is #{networks}"

#template "/etc/postfix/main.cf" do
#	source "main.cf.erb"
#	mode "0644"
#	owner "root"
#	group "root"
#	variables ({
#		:my_hostname => node[:postfix][:my_hostname],
#		:my_domain => node[:postfix][:my_domain],
#		:smtp_server => node[:postfix][:smtp_server],
#		:smtp_port => node[:postfix][:smtp_port],
#		:smtp_auth_reqd => smtp_auth_reqd,
#		:networks => networks,
#		:mail_folder => node[:postfix][:mail_folder],
#		:virtual_uid => node[:postfix][:mail_uid],
#		:virtual_gid => node[:postfix][:mail_gid]
#	})
#	notifies :restart, "service[postfix]"
#end

if not node[:postfix].has_key?("required_mount") or
	Regexp.new(node[:postfix][:required_mount]).match(`mount`)

	mail_root = node[:postfix][:mail_folder]
	mail_owner = node[:postfix][:mail_owner]
	mail_group = node[:postfix][:mail_group]
	folders = %w{cur new tmp .Drafts .Sent .Trash .Templates}
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
			end
			folders.each do |f|
				directory "#{mail_root}/#{domain}/#{umf}/#{f}" do
					owner mail_owner
					group mail_group
					recursive true
					mode "0770"
					action :create
				end
			end
		end
	end
end
