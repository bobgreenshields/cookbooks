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

include_recipe "apt::update"
# luks installs cryptsetup
include_recipe "luks"

apt_package "lvm2" do
	action :install
end

%w(data secure).each do |dir|
	directory "/mnt/#{dir}" do
		mode "0755"
		owner "bobg"
		group "bobg"
		action :create
	end
end

directory "/home/bobg/chef/lvm" do
	mode "0755"
	owner "bobg"
	group "bobg"
	action :create
	recursive true
end

cookbook_file "/home/bobg/chef/lvm/encryptedLVMHowTo" do
	source "encryptedLVMHowTo"
	mode "0744"
	owner "bobg"
	group "bobg"
end
