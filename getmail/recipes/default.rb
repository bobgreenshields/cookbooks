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


package "getmail4" do
	action :install
end

directory "/home/vmail/.getmail" do
	action :create
	owner "vmail"
	group "vmail"
	mode "0755"
end

log node[:getmail][:log_path]
log node[:getmail][:log_file]
log_path = node[:getmail][:log_path]
log_file = node[:getmail][:log_file]
message_log = "#{log_path}/#{log_file}"

directory log_path do
	action :create
	owner "vmail"
	group "vmail"
	mode "0755"
end

file message_log do
	action :create_if_missing
	owner "vmail"
	group "vmail"
	mode "0644"
end


node["getmail"]["rc"].each do |name, details|
	template "/home/vmail/.getmail/#{name}.rc" do
		source "rc.erb"
		mode "0640"
		owner "vmail"
		group "vmail"
		variables ({
			:retrvr_type => node[:getmail][:retrvr_type],
			:server => details["server"],
			:username => details["username"],
			:password => details["password"],
			:mail_path => details["mail_path"],
			:verbose_level => node[:getmail][:verbose_level],
			:read_all => node[:getmail][:read_all],
			:delete_after => node[:getmail][:delete_after],
			:message_log => message_log
		})
	end
end

site_ruby = node["getmail"]["site_ruby"]
log ("site_ruby dir is #{site_ruby}")

unless File.exist?(site_ruby)
	log("Could not find site_ruby dir #{site_ruby}") { level :fatal }
#	Chef::Log.fatal("Could not find site_ruby dir #{site_ruby}")
end

getmail_folder = File.join(site_ruby, "getmail")

git getmail_folder do
	repository "git@github.com:bobgreenshields/getmail.git"
	reference "master"
	action :sync
end


