mail_owner = node[:postfix][:mail_owner]
mail_group = node[:postfix][:mail_group]
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
