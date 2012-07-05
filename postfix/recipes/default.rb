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

if node[:postfix].has_key?("smtp_login")
	template "/etc/postfix/saslpasswd" do
		source "saslpasswd.erb"
		mode "0644"
		owner "root"
		group "root"
		variables (
			:server => node[:postfix][:smtp_server]
#			:login => node[:postfix][:smtp_login],
#			:password => node[:postfix][:smtp_password]
		)
	end
end

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
