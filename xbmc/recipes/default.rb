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

#use this to enable passwd for user xbmc
gem_package "libshadow" do
	action :install
end

user "xbmc" do
	comment "user for xbmc"
	uid "1024"
	gid "users"
	home "/home/xbmc"
	shell "/bin/bash"
	password "$1$L5NNsQs9$x.1yp5..GEtZw45xljSRw0"
end

group "video" do
	members ['bobg', 'xbmc']
	append true
end

directory "/home/xbmc" do
	owner "xbmc"
	group "users"
	mode "0755"
	action :create
end

execute "update-apt" do
	command "apt-get update"
	user "root"
	action :nothing
end

# for nvidia drivers
apt_package "nvidia-current" do
	action :install
end

# for nvidia hardware acceleration
apt_package "libvdpau1" do
	action :install
end

bobscode_repository "lucid-bleed" do
	action :add
	provider "bobscode_ppa"
	notifies :run, "execute[update-apt]"
end

apt_package "vdpau-va-driver" do
	action :install
end

# begin xbmc install by checking dependancies
prepack = %w(python-software-properties pkg-config)
prepack.each do |p|
	apt_package p do
		action :install
	end
end

bobscode_repository "team-xbmc" do
	action :add
	provider "bobscode_ppa"
	notifies :run, "execute[update-apt]"
end

##bobscode_repository "dropbox" do
##	action :add
##	key "5044912E"
##	keyserver "pgp.mit.edu"
##	provider "bobscode_repository"
##end

xbmc_pack = %w(xbmc xbmc-standalone)
xbmc_pack.each do |x|
	apt_package x do
		action :install
	end
end

