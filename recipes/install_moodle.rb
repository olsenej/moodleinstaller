#
# Cookbook Name:: chef-umn-automoodle
# Recipe:: install_moodle.rb
#
# Copyright (C) 2016
# University of Minnesota
# Edward Olsen (ejolsen@umn.edu)
#
# All rights reserved - Do Not Redistribute

chef_gem 'chef-vault' do
    compile_time true if respond_to?(:compile_time)
end
require 'chef-vault'

### Set some variables based on node role
validator_keys_vault = node['chef-umn-automoodle']['validator_keys_vault']
validator_keys_item = node['chef-umn-automoodle']['validator_keys_item']

directory '/home/oit-moodle' do
	action :create
        owner 'oit-moodle'
        group 'oit-moodle'
	mode '0755'
end
directory '/home/oit-moodle/.ssh' do
	action :create
	owner 'oit-moodle'
	group 'oit-moodle'
	mode '0700'
end
directory '/home/oit-moodle/3.0' do
	action :create
        owner 'oit-moodle'
        group 'oit-moodle'
	mode '0755'
end
item = ChefVault::Item.load(validator_keys_vault, validator_keys_item)
item.each do |key, value|
    next if key == 'id'
    next if key == 'comments'
    key_filename = 'id_rsa'
    file key_filename do
	path '/home/oit-moodle/.ssh/id_rsa'
        content value
        owner 'oit-moodle'
        group 'oit-moodle'
        mode '0600'
        action :create
    end
end
cookbook_file '/home/oit-moodle/.ssh/known_hosts' do
	source 'known_hosts'
	owner 'oit-moodle'
	group 'oit-moodle'
	mode '0644'
	action :create
end
cookbook_file '/home/oit-moodle/.ssh/authorized_keys' do
        source 'authorized_keys'
        owner 'oit-moodle'
        group 'oit-moodle'
        mode '0644'
        action :create
end


if node.role?('ay16_prd_web')
	checkout_branch_docs = "prod30"
elsif node.role?('ay16_qa_web')
	checkout_branch_docs = "qa30"
elsif node.role?('ay16_tst')
	checkout_branch_docs = "test30"
else
	checkout_branch_docs = "dev30"
end

git '/home/oit-moodle/3.0/config' do
	repository 'REDACTED'
	checkout_branch 'master'
	revision 'master'
	enable_checkout false
	user 'oit-moodle'
	group 'oit-moodle'
	action :sync
end
git '/home/oit-moodle/3.0/docs' do
	repository 'REDACTED'
	checkout_branch checkout_branch_docs
	revision checkout_branch_docs
	user 'oit-moodle'
	group 'oit-moodle'
	action :sync
end


link '/home/oit-moodle/default' do
	to '/home/oit-moodle/3.0/docs'
	owner 'oit-moodle'
	group 'oit-moodle'
end
if node.role?('ay16_prd_web')
	link '/home/oit-moodle/3.0/docs/config-env.php' do
        	to '/home/oit-moodle/3.0/config/config-env-prod30.php'
        	owner 'oit-moodle'
        	group 'oit-moodle'
	end
elsif node.role?('ay16_qa_web')
	link '/home/oit-moodle/3.0/docs/config-env.php' do
        	to '/home/oit-moodle/3.0/config/config-env-qa30.php'
        	owner 'oit-moodle'
        	group 'oit-moodle'
	end
elsif node.role?('ay16_tst')
	link '/home/oit-moodle/3.0/docs/config-env.php' do
        	to '/home/oit-moodle/3.0/config/config-env-test30.php'
        	owner 'oit-moodle'
        	group 'oit-moodle'
	end
else
	link '/home/oit-moodle/3.0/docs/config-env.php' do
        	to '/home/oit-moodle/3.0/config/config-env-dev30.php'
        	owner 'oit-moodle'
        	group 'oit-moodle'
	end
end
link '/home/oit-moodle/3.0/docs/config.php' do
	to '/home/oit-moodle/3.0/docs/config-main.php'
	owner 'oit-moodle'
	group 'oit-moodle'
end

