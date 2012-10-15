mail_owner = node[:mail][:mail_owner]
mail_group = node[:mail][:mail_group]
mail_uid = node[:mail][:mail_uid].to_i
mail_gid = node[:mail][:mail_gid].to_i
mail_folder = node[:mail][:mail_folder]
required_mount = node[:mail][:required_mount]

group mail_group do
	gid mail_gid
end

user mail_owner do
	action :create
	uid mail_uid
	gid mail_gid
	home "/home/#{mail_owner}"
	shell "/bin/bash"
	supports :manage_home => true
end

directory "/mnt/mail" do
	owner mail_owner
	group mail_group
	mode "0770"
	action :create
end

mount "/mnt/mail" do
	device "galactica:/mnt/secure/mail"
	fstype "nfs"
	options "rw"
	action [:mount, :enable]
end

directory mail_folder do
	owner mail_owner
	group mail_group
	mode "0770"
	action :create
	recursive true
	only_if do
		Regexp.new(required_mount).match(`mount`)
	end
end
