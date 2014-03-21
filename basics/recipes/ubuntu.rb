#
# Cookbook Name:: basics
# Recipe:: default
#
# Copyright 2012, Cogini
#


include_recipe 'apt'
include_recipe 'apt::disable_recommends'
