#
# Cookbook Name:: estudy
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

execute "yum update" do
  command "yum update"
end

%(git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel
  libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl).each do |pkg|
    package pkg
  end


include_recipe 'ruby_build'
rbenv_script "bundle_install" do
  rbenv_version "2.3.0"
  user          "vagrant"
  cwd           "/home/vagrant/estudy"
  code          %{bundle install}
end