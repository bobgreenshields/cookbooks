default['lms']['lms_deb_version'] = "7.7.2"
default['lms']['lms_deb_file'] = "logitechmediaserver_#{node['lms']['lms_deb_version']}_all.deb"
default["lms"]["lms_deb_url"] = 
	"https://dl.dropboxusercontent.com/u/12882307/chef/#{node['lms']['lms_deb_file']}"
node.default['lms']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? "amd64" : "i386"
