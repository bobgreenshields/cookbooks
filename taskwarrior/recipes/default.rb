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

if (node[:platform] == "ubuntu") and (node[:platform_version].to_f >= 10.10) then
  package "task" do
    action :install
  end
end

cookbook_file "/home/bobg/.taskrc" do
  source "taskrc"
  mode "0644"
  owner "bobg"
  group "bobg"
  action :create_if_missing
end
