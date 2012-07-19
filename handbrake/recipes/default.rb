
repo_name = 'stebbins/handbrake-releases'

execute "apt-get update" do
	user "root"
	action :nothing
end

execute "add gnome-do repository" do
	user "root"
	command "add-apt-repository ppa:#{repo_name}"
#	only_if do File.read(sources_file).select{|v| v =~ /#{repos}/}.length == 0 end
	notifies :run, "execute[apt-get update]", :immediately
end
