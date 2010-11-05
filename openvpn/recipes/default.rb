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

apt_package "openvpn" do
	action :install
end

directory "/etc/openvpn" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

%w{hill-house-bobg.crt hill-house-bobg.key hill-house-ca.crt hill-house.ovpn}.each do |fl|
	cookbook_file "/etc/openvpn/#{fl}" do
		source fl
		mode "0644"
		owner "root"
	end
end
