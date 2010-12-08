sources_dir = '/etc/apt/sources.list.d'
#codename = node[:lsb][:codename]

action :add do
	if (node[:platform] == "ubuntu") and (node[:platform_version].to_f >= 9.10) then 
		unless @ppa.exists
			execute "add #{new_resource.name} repository" do
				user "root"
				command "add-apt-repository ppa:#{new_resource.name}/ppa"
#				creates File.join(sources_dir, "#{new_resource.name}-ppa-#{node[:lsb][:codename]}.list")
			end
			new_resource.updated_by_last_action(true)
		end
	else
		Chef::Log.error("Cannot use bobscode_ppa resource unless on Ubuntu 9.10 or higher")
	end

end



def load_current_resource
#  @smbuser = Chef::Resource::SambaUser.new(new_resource.name)
  @ppa = Chef::Resource::BobscodePpa.new(new_resource.name)
  sources_file = File.join(sources_dir, "#{new_resource.name}-ppa-#{node[:lsb][:codename]}.list"
  exists = File.exists? sources_file
  @ppa.exists(exists)
end
