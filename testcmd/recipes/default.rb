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


#pwd = node[:pwd]
#user = node[:user]
#
#Chef::Log::info pwd
#Chef::Log::info user
#execute "new smbpasswd of #{pwd} for #{user}" do
#	command "(echo #{pwd}; echo #{pwd} ) | smbpasswd -s -a #{user}"
#	action :run
#end
#smb_users = node[:samba_users]
#smb_users.each do |u|
#	Chef::Log.info "Adding samba user #{u['id']} with pword #{u['smbpasswd']}"
#	bobscode_smbuser u["id"] do
#		password u["smbpasswd"]
#		overwrite false
##		action [:create, :enable]
#		action [:create]
#		provider "bobscode_smbuser"
#	end
#end

#bobscode_module "dm-crypt" do
##bobscode_module "dm_crypt" do
##bobscode_module "blurby-crypt" do
#	action :install
#	provider "bobscode_module"
#end
smbu = {"id" => "test", "smbpassword" => ""}
smb_users = []
smb_users << smbu

smb_users.each do |u|
	testcmd_user u["id"] do
		provider "testcmd_bobuser"
		password u["smbpassword"]
		action [:create]
end



