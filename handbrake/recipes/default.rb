sources_file = ::File.join(node[:handbrake][:sources][:dir],
	node[:handbrake][:sources][:file])

execute "apt-get update" do
	user "root"
	action :nothing
end

execute "add gnome-do repository" do
	user "root"
	command "add-apt-repository ppa:#{node[:handbrake][:repo_name]}"
	creates sources_file
	notifies :run, "execute[apt-get update]", :immediately
end
