sources_file = ::File.join(node[:everpad][:sources][:dir],
	node[:everpad][:sources][:file])

execute "apt-get update" do
	user "root"
	action :nothing
end

execute "add everpad ppa" do
	user "root"
	command "add-apt-repository ppa:#{node[:everpad][:repo_name]}"
	creates sources_file
	notifies :run, "execute[apt-get update]", :immediately
end

package "everpad" do
	action :install
end
