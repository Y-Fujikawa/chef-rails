#
# Cookbook Name:: ruby-env
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 必要となるものを事前にインストール
%w{git openssl-devel sqlite-devel}.each do |pkg|
  package pkg do
    action :install
  end
end

# ディレクトリがある場合、配置しない
git "/home/#{node['ruby-env']['user']}/.rbenv" do
  # GitHubから最新のリポジトリを取得
  repository node['ruby-env']['rbenv_url']
  action :sync
  user node['ruby-env']['user']
  group node['ruby-env']['group']
end

# rbenv実行に.bash_profileを書き換え
template ".bash_profile" do
  source ".bash_profile.erb"
  path "/home/#{node['ruby-env']['user']}/.bash_profile"
  mode 0644
  owner node['ruby-env']['user']
  group node['ruby-env']['group']
  # bash_profile内を検索してrbenvがある場合、書き換えない
  not_if "grep rbenv ~/.bash_profile", :environment => { :'HOME' => "/home/#{node['ruby-env']['user']}" }
end

# .rbenv/pluginsを作成後、ruby-buildを配置する
directory "/home/#{node['ruby-env']['user']}/.rbenv/plugins" do
  owner node['ruby-env']['user']
  group node['ruby-env']['group']
  mode 0755
  action :create
end

# .rbenv/pluginsを作成
git "/home/#{node['ruby-env']['user']}/.rbenv/plugins/ruby-build" do
  repository node['ruby-env']['ruby-build_url']
  action :sync
  user node['ruby-env']['user']
  group node['ruby-env']['group']
end

# rbenv install 2.1.2コマンドを実行
execute "rbenv install #{node['ruby-env']['version']}" do
  command "/home/#{node['ruby-env']['user']}/.rbenv/bin/rbenv install #{node['ruby-env']['version']}"
  user node['ruby-env']['user']
  group node['ruby-env']['group']
  environment 'HOME' => "/home/#{node['ruby-env']['user']}"
  not_if { File.exists?("/home/#{node['ruby-env']['user']}/.rbenv/versions/#{node['ruby-env']['version']}") }
end
