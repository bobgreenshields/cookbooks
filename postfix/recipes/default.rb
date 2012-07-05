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
	folders = %w{cur new tmp .Drafts .Sent .Trash .Templates}
	node[:postfix][:domains].each do |domain, dom_data|
		dom_data["users"].each do |user|
			folders.each do |folder|
				dir_arr = [] << mail_root << domain
				dir_arr << user["mail_folder"] << folder
				dir_name = dir_arr.join('/')
				puts "building dir #{dir_name}"
				end
			end
		end
	end




end
