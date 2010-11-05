
#codename = node[:lsb][:codename]

action :add do
	Chef::Log.info("Adding repository for: #{new_resource.name}")
# amend sources_dir on line below
#	sources_dir = '/home/bobg'
	sources_dir = '/etc/apt/sources.list.d'
  template "#{sources_dir}/#{new_resource.name}-#{node[:lsb][:codename]}.list" do
  	source "#{new_resource.name}.erb"
  	mode "0644"
  	owner "root"
  	group "root"
  	variables({:codename => node[:lsb][:codename]})
#  	variables({:codename => "lucid"})
  end
	if new_resource.key.nil? then
		Chef::Log.debug("#{new_resource.name} key attribute is nil")
	else
		Chef::Log.debug("#{new_resource.name} key is: #{new_resource.key}")
		found = `apt-key list` =~ /#{new_resource.key}/
		if found then
			Chef::Log.debug("#{new_resource.name} key: #{new_resource.key} found at #{found}")
		else
			Chef::Log.debug("#{new_resource.name} key: #{new_resource.key} NOT found")
			case
			when new_resource.keyserver
				execute "Install #{new_resource.name} key from keyserver #{new_resource.keyserver}" do
					command "apt-key adv --keyserver #{new_resource.keyserver} --recv-keys #{new_resource.key}"
					user "root"
					action :run
				end
			when new_resource.url
				execute "Install #{new_resource.name} key from #{new_resource.url}" do
					command "wget -q #{new_resource.url} -O- | apt-key add -"
					user "root"
					action :run
				end
			else
				Chef::Log.error("#{new_resource.name} key not found and both keyserver and URL attribute is nil")
			end
			
			
#			if new_resource.keyserver.nil? then
#				Chef::Log.error("#{new_resource.name} key not found and keyserver attribute is nil")
#			else
#				#look up apt add-key command and execute it here on the keyserver
#			end
		end
	end
end



