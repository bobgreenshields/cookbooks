
addon_dir = "/home/bobg/tb-addons"

directory addon_dir do
	owner "bobg"
	group "bobg"
	mode "0755"
	action :create
end

addons = node["thunderbird"]["addons"]

addons.each do |a|
	cookbook_file "#{addon_dir}/#{a}" do
		source a
		mode "0755"
		owner "bobg"
		group "bobg"
		action :create_if_missing
	end
end
