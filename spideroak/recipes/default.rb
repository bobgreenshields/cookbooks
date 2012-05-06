#
# Cookbook Name:: spideroak
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
apt_repository "spideroak" do
  repo_desc "deb http://apt.spideroak.com/ubuntu-spideroak-hardy/ release restricted"  
  sources_list_filename "spideroak.com.sources.list"
  key "https://spideroak.com/dist/spideroak-apt-2010.asc"
end

apt_package "spideroak" do
	action :install
end
