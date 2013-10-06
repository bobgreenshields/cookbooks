default['everpad']['repo_name'] = 'nvbn-rm/ppa'
default['everpad']['sources']['file'] =
	"nvbn-rm-ppa-#{node[:lsb][:codename]}.list"
default['everpad']['sources']['dir'] = '/etc/apt/sources.list.d'
