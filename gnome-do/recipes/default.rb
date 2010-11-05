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
sources_file = '/etc/apt/sources.list'
gnmdo_tag = 'http://ppa.launchpad.net/do-core/ppa/ubuntu'
repos = 'do-core/ppa'

execute "apt-get update" do
	action :nothing
end

#execute "add gnome-do repository" do
#	user "root"
#	command "add-apt-repository ppa:#{repos}"
#	only_if do File.read(sources_file).select{|v| v =~ /#{repos}/}.length == 0 end
#	notifies :run, resources(:execute => "apt-get update"), :immediately
#end

%w{gnome-do}.each do |p|
	apt_package p do
		action :install
	end
end
