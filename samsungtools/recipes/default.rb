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

repository = 'deb http://ppa.launchpad.net/voria/ppa'
sources_file = '/etc/apt/sources.list'

execute "apt-get update" do
	action :nothing
end

#execute "add voria repository" do
#	user "root"
#	command "add-apt-repository ppa:voria/ppa"
#	notifies :run, resources(:execute => "apt-get update"), :immediately
#end

%w{samsung-tools samsung-backlight}.each do |p|
	apt_package p do
		action :install
	end
end

%w{95-keymap.rules 95-keyboard-force-release.rules}.each do |f|
	cookbook_file "/lib/udev/rules.d/#{f}" do
		source f
		owner "root"
		group "root"
		mode "0644"
	end
end

