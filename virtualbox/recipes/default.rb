#
# Cookbook Name:: hosts
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

vbox_repos = 'deb http://download.virtualbox.org/virtualbox/debian karmic non-free'
sources_file = '/etc/apt/sources.list'
comment = '# virtual box repository'

execute "apt-get update" do
	action :nothing
end

execute "add virtualbox to sources" do
	user "root"
	command "echo \"\n#{comment}\n#{vbox_repos}\" >> #{sources_file}"
	not_if do File.read(sources_file).include?(vbox_repos) end
	notifies :run, resources(:execute => "apt-get update"), :immediately
end

KEY_NAME = 'xVM VirtualBox archive signing key'

execute "add virtualbox public key" do
	user "root"
	#command "echo \"add key #{KEY_NAME} run\" >> /home/bobg/tests/test.list"
	command 'wget -q http://download.virtualbox.org/virtualbox/debian/sun_vbox.asc -O- | apt-key add -'
	not_if do `apt-key list`.include?(KEY_NAME) end
end

%w{virtualbox-3.1 dkms}.each do |p|
	apt_package p do
		action :install
	end
end

if node[:vboxusers] then
	usersarr = node[:vboxusers]
	group "vboxusers" do
		members usersarr
		append true
	end
else
	log "No users added to vboxusers group"
end
