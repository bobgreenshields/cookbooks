mount "/mnt/mail" do
	device "galactica:/mnt/secure/mail"
	fstype "nfs"
	options "rw"
	action [:mount, :enable]
end
