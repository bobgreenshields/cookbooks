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


execute "update-apt-for-vim-74" do
	command "apt-get update"
	user "root"
	action :nothing
end

ppa_sources_file = '/etc/apt/sources.list.d/fcwu-tw-ppa-raring.list'

if (node[:platform] == "ubuntu") and (node[:platform_version].to_f <= 13.04) then
  execute "add ppa for vim 7.4" do
  	command "add-apt-repository ppa:fcwu-tw/ppa"
  	user "root"
  	notifies :run, "execute[update-apt-for-vim-74]", :immediately
        not_if { ::File.exists?(ppa_sources_file) }
  end
end


%w{vim-gnome}.each do |p|
	package p do
		action :install
	end
end

