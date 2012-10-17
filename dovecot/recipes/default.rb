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
		:domains => node[:dovecot][:domains],
		:mail_folder => node[:dovecot][:mail_folder]
	})
end

template "/etc/dovecot/dovecot.conf" do
	source "conf.erb"
	mode "0644"
	owner "root"
	group "root"
	variables ({
		:base_dir => node[:dovecot][:base_dir],
		:protocols => node[:dovecot][:protocols],
		:disable_plaintext_auth => node[:dovecot][:disable_plaintext_auth],
		:log_timestamp => node[:dovecot][:log_timestamp],
		:ssl_disable => node[:dovecot][:ssl_disable],
		:login_greeting => node[:dovecot][:login_greeting],
		:mail_location => node[:dovecot][:mail_location],
		:valid_chroot_dirs => node[:dovecot][:valid_chroot_dirs],
		:auth_default => node[:dovecot][:auth_default]
	})
	notifies :restart, "service[dovecot]"
end
