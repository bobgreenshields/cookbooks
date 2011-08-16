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

%w{thunderbird thunderbird-gnome-support}.each do |package|
	apt_package package do
		action :install
	end
end

addon_dir = "/home/bobg/tb-addons"

directory addon_dir do
	owner "bobg"
	group "bobg"
	mode "0755"
	action :create
end

addons = %w(exteditor_v100.xpi nostalgy-0.2.27-tb+sm.xpi
	zindus-0.8.33-tb+sm.xpi)

addons.each do |a|
	cookbook_file "#{addon_dir}/#{a}" do
		source a
		mode "0755"
		owner "bobg"
		group "bobg"
		action :create_if_missing
	end
end
