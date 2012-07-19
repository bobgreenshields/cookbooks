
repo_name = 'stebbins/handbrake-releases'

codename = node[:lsb][:codename]
sources_file = "stebbins-handbrake-releases-#{codename}.list"

execute "apt-get update" do
	user "root"
	action :nothing
end

execute "add gnome-do repository" do
	user "root"
	command "add-apt-repository ppa:#{repo_name}"
	creates sources_file
	notifies :run, "execute[apt-get update]", :immediately
end
