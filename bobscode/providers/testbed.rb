
sources_dir = '/home/bobg'
#codename = node[:lsb][:codename]

action :add do
  template "#{sources_dir}/#{new_resource.name}-#{node[:lsb][:codename]}.list" do
  	source "#{new_resource.name}.erb"
  	mode "0644"
  	owner "root"
  	group "root"
#  	variables({:codename => node[:lsb][:codename]})
  	variables({:codename => "lucid"})
  end
	Chef::Log.info("Testbed add called: #{new_resource.name}")
	if new_resource.key.nil? then
		Chef::Log.info("#{new_resource.name} key attribute is nil")
	else
		Chef::Log.info("Key is: #{new_resource.key}")
		found = `apt-key list` =~ /#{new_resource.key}/
		if found then
			Chef::Log.info("Key #{new_resource.key} found at #{found}")
		else
			Chef::Log.info("Key #{new_resource.key} NOT found")
			if new_resource.keyserver.nil? then
				Chef::Log.info("#{new_resource.name} keyserver attribute is nil")
			else
			end
		end
	end
end



