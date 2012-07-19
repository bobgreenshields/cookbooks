default['handbrake']['repo_name'] = 'stebbins/handbrake-releases'
default['handbrake']['sources']['file'] =
	"stebbins-handbrake-releases-#{node[:lsb][:codename]}.list"
default['handbrake']['sources']['dir'] = '/etc/apt/sources.list.d'
