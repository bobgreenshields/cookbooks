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

#execute "apt-get update" do
#	action :run
#end

include_recipe "apt::update"

apt_package "mdadm" do
	action :install
end

directory "/home/bobg/chef/mdadm" do
	mode "0755"
	owner "bobg"
	group "bobg"
	action :create
	recursive true
end

cookbook_file "/home/bobg/chef/mdadm/createarray" do
	source "createarray"
	mode "0744"
	owner "bobg"
	group "bobg"
end
