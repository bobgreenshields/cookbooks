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

#repository = 'keepassx'
#sources_dir = '/etc/apt/sources.list.d'
#codename = node[:lsb][:codename]

#Chef::Log.info("Codename is #{codename}")

#execute "add #{repository} repository" do
#	user "root"
#	command "add-apt-repository ppa:#{repository}/ppa"
#	creates File.join(sources_dir, "#{repository}-ppa-#{codename}.list")
#end

#execute "apt-get update" do
#end

execute "update apt for keepassx" do
	command "apt-get update"
	user "root"
	action :nothing
end

if (node[:platform] == "ubuntu") and (node[:platform_version].to_f < 11.04) then
  bobscode_repository "keepassx" do
  	action :add
  	provider "bobscode_ppa"
  	notifies :run, "execute[update-apt]"
  end
end

%w{keepassx}.each do |p|
	apt_package p do
		action :install
	end
end
