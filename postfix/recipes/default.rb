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
			directory "#{mail_root}/#{domain}/#{user["mail_folder"]}" do
				owner mail_owner
				group mail_group
				mode "0770"
				action :create
			end
			folders.each do |folder|
				dir_arr = [] << mail_root << domain
				dir_arr << user["mail_folder"] << folder
				dir_name = dir_arr.join('/')
#				puts "building dir #{dir_name}"
				directory dir_name do
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
