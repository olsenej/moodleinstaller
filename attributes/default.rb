#
# Cookbook Name:: chef-umn-automoodle
# Recipe:: default.rb
#
# Copyright (C) 2016
# University of Minnesota
# Edward Olsen (ejolsen@umn.edu)
#
# All rights reserved - Do Not Redistribute


node.default['chef-umn-automoodle']['validator_keys_vault'] = 'moodle_keys'
node.default['chef-umn-automoodle']['validator_keys_item'] = 'oit-moodle'
