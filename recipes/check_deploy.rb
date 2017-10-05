#
# Cookbook Name:: chef-umn-automoodle
# Recipe:: check_deploy.rb
#
# Copyright (C) 2016
# University of Minnesota
# Edward Olsen (ejolsen@umn.edu)
#
# All rights reserved - Do Not Redistribute

already_deployed = File.exists?('/home/oit-moodle/3.0')
include_recipe "chef-umn-automoodle::install_moodle" if not already_deployed
