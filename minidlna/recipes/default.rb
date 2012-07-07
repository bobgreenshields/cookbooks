#installs minidlna server
package "minidlna" do
	action :install
end

dir_strs = node[:minidlna][:media_dirs].inject([]) do |arr, dir_data|
	dir_str = "media_dir="
	dir_str << dir_data.has_key?("restriction") ? "#{dir_data["restriction"]}," : ""
	dir_str << dir_data["location"]
	arr << dir_str
end
