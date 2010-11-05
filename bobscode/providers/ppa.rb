sources_dir = '/etc/apt/sources.list.d'
#codename = node[:lsb][:codename]

action :add do
#  execute "create database" do
#    not_if "mysql -e 'show databases;' | grep #{new_resource.name}"
#    command "mysqladmin create #{new_resource.name}"
#  end
	if (node[:platform] == "ubuntu") and (node[:platform_version].to_f >= 9.10) then 
		execute "add #{new_resource.name} repository" do
			user "root"
			command "add-apt-repository ppa:#{new_resource.name}/ppa"
			creates File.join(sources_dir, "#{new_resource.name}-ppa-#{node[:lsb][:codename]}.list")
		end
	else
		Chef::Log.error("Cannot use bobscode_ppa resource unless on Ubuntu 9.10 or higher")
	end

end



