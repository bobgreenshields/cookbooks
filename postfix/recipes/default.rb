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

#	mail_root = node[:postfix][:mail_folder]
#	folders = %w{cur new tmp .Drafts .Sent .Trash .Templates}


puts "building dirctories"


end
