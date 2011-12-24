#
# Cookbook Name:: ruplite
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

# make sure we have github as a rubygems source
execute 'gem sources -a http://gems.github.com' do
	user "root"
	not_if { `gem sources` =~ /gems.github.com/ }
end

#install open4 gem
gem_package "open4" do
	action :install
end

source_dir = "#{node['site-ruby']}/ruplite"

directory source_dir do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

git source_dir do
	repository "git://github.com/bobgreenshields/ruplite.git"
	reference "master"
	action :sync
end

link "#{node['site-ruby']}/ruplite.rb" do
	to "#{source_dir}/lib/ruplite.rb"
end
