%w{dovecot-common dovecot-imapd}.each do |p|
	package p do
		action :install
	end
end

template "/etc/dovecot/passwd" do
	source "passwd.erb"
	mode "0660"
	owner "root"
	group "root"
	variables ({
		:domains => node[:dovecot][:domains]
	})
end

