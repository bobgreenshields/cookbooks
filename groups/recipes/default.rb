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

if node[:groups]
	groups = node[:groups]
	groups.each do |g|
#		Chef::Log::info g.inspect
		group g["id"] do
			gid g["gid"]
			members g["members"]
		end
	end
end

#users = node[:users]
#
#users.each do |u|
#
#	home_dir = "/home/#{u['id']}"
#
#	user u['id'] do
#		uid u['uid']
#		gid "users"
#		shell u['shell']
#		comment u['comment']
#		password u['password']
#		if (u['home_dir'].upcase == "TRUE") then
#			supports :manage_home => true
#			home home_dir
#		end
#	end
#end
