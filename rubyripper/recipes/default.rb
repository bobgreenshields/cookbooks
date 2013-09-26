#
# Cookbook Name:: 
# Recipe:: default
#
# Copyright 2013, Bob Greenshields
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
require_recipe "audio::lame"
require_recipe "audio::flac"
require_recipe "audio::cdrdao"

execute "add_repo_gpg_key" do
	command "wget -q -O- http://archive.getdeb.net/getdeb-archive.key | apt-key add -"
	action :nothing
end

execute "update_apt" do
	command "apt-get update"
	action :nothing
end

cookbook_file "getdeb-raring.list" do
	path "/etc/apt/sources.list.d/getdeb-raring.list"
	action :create_if_missing
	owner "root"
	group "root"
	mode "644"
	notifies :run, "execute[add_repo_gpg_key]", :immediately
	notifies :run, "execute[update_apt]", :immediately
end

package "rubyripper" do
	action :install
end

