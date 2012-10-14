%w{dovecot-common dovecot-imapd}.each do |p|
	package p do
		action :install
	end
end

service "dovecot" do
	supports :restart => true, :start => true, :stop => true
	action :nothing
end

template "/etc/dovecot/passwd" do
	source "passwd.erb"
	mode "0640"
	owner "root"
	group "root"
	variables ({
		:domains => node[:dovecot][:domains]
	})
end

template "/etc/dovecot/users" do
	source "users.erb"
	mode "0644"
	owner "root"
	group "root"
	variables ({
		:domains => node[:dovecot][:domains]
	})
end

template "/etc/dovecot/dovecot.conf" do
	source "conf2.erb"
	mode "0644"
	owner "root"
	group "root"
	variables ({
		:base_dir => node[:postfix][:base_dir],
		:protocols => node[:postfix][:protocols],
		:disable_plaintext_auth => node[:postfix][:disable_plaintext_auth],
		:log_timestamp => node[:postfix][:log_timestamp],
		:ssl_disable => node[:postfix][:ssl_disable],
		:login_greeting => node[:postfix][:login_greeting],
		:mail_location => node[:postfix][:mail_location],
		:valid_chroot_dirs => node[:postfix][:valid_chroot_dirs],
		:auth_default => node[:postfix][:auth_default]
	})
	notifies :restart, "service[dovecot]"
end
