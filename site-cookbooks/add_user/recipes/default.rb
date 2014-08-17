#
# Cookbook Name:: add_user
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
user "ops" do
  action :create
  supports :manage_home => true
  home "/home/#{node['user']}"
  shell "/bin/bash"
end

directory "/home/#{node['user']}/.ssh" do
  action :create
  owner node['user']
  mode 0700
end

cookbook_file "/home/#{node['user']}/.ssh/id_rsa" do
  action :create
  owner node['user']
  mode 0600
  not_if { File.exists?("/home/#{node['user']}/.ssh/id_rsa") }
end

cookbook_file "/home/#{node['user']}/.ssh/authorized_keys" do
  action :create
  owner node['user']
  mode 0600
  not_if { File.exists?("/home/#{node['user']}/.ssh/authorized_keys") }
end
