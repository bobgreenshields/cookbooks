#
# Cookbook Name:: samba
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

#users = nil
#shares = data_bag_item("samba", "shares")
shares = node[:shares]
smb_share_meta = {}
shares.each do |k,v|
	smb_share_meta[k] = v["smb_meta"]
end

shares.each do |k,v|
  if v["smb_meta"].has_key?("path")
    directory v["smb_meta"]["path"] do
    	owner v["owner"]
    	group v["group"]
    	mode v["mode"]
      recursive true
    end
  end
end

#unless node["samba"]["passdb_backend"] =~ /^ldapsam/
#  users = search("users", "*:*")
#end

smb_users = node[:samba_users]

package value_for_platform(
  ["ubuntu", "debian", "arch"] => { "default" => "samba" },
  ["redhat", "centos", "fedora"] => { "default" => "samba3x" },
  "default" => "samba"
)

#svcs = value_for_platform(
#  ["ubuntu", "debian"] => { "default" => ["smbd", "nmdb"] },
#  ["redhat", "centos", "fedora"] => { "default" => ["smb", "nmb"] },
#  "arch" => { "default" => [ "samba" ] },
#  "default" => ["smbd", "nmdb"]
#)

#svcs.each do |s|
#  service s do
#    pattern "smbd|nmbd" if node["platform"] =~ /^arch$/
#    action [:enable, :start]
#  end
#end

service "smbd" do
	supports :status => true, :restart => true, :reload => true
	action [:enable, :start]
end

service "nmbd" do
	supports :status => true, :restart => true, :reload => true
	action [:enable, :start]
end

svcs = ["smbd", "nmbd"]

template node["samba"]["config"] do
  source "smb.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables :shares => smb_share_meta
  notifies :restart, resources(:service => svcs)
#  notifies :restart, "service[smbd]"
end

smb_users.each do |u|
	Chef::Log.info "Adding samba user #{u['id']} with pword #{u['smbpasswd']}"
	bobscode_smbuser u["id"] do
		password u["smbpasswd"]
		overwrite false
		action [:create, :enable]
		provider "bobscode_smbuser"
	end
end
