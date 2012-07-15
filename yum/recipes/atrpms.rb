#
# Cookbook Name:: yum
# Recipe:: atrpms
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

package_name = "atrpms-repo"

if node.platform_version.to_f >= 6 and node.platform_version.to_f < 7
    execute "atrpms el6 64bit" do
        #64bit system
        command "rpm -i http://dl.atrpms.net/all/#{package_name}-6-5.el6.x86_64.rpm"
        only_if "
            if uname -m | grep 64 && (if rpm -q #{package_name}; then exit 1; else exit 0; fi)
            then exit 0
            else exit 1
            fi
        "
    end

    execute "atrpms el6 32bit" do
        #32bit system
        command "rpm -i http://dl.atrpms.net/all/#{package_name}-6-5.el6.i686.rpm"
        only_if "
            if uname -m | grep-v 64 && (if rpm -q #{package_name}; then exit 1; else exit 0; fi)
            then exit 0
            else exit 1
            fi
        "
    end

elsif node.platform_version.to_f >= 5 and node.platform_version.to_f < 6
    execute "atrpms el5 64bit" do
        #64bit system
        command "rpm -i http://dl.atrpms.net/all/#{package_name}-5-5.el5.x86_64.rpm"
        only_if "
            if uname -m | grep 64 && (if rpm -q #{package_name}; then exit 1; else exit 0; fi)
            then exit 0
            else exit 1
            fi
        "
    end

    execute "atrpms el5 32bit" do
        #32bit system
        command "rpm -i http://dl.atrpms.net/all/#{package_name}-5-5.el5.i386.rpm"
        only_if "
            if uname -m | grep -v 64 && (if rpm -q #{package_name}; then exit 1; else exit 0; fi)
            then exit 0
            else exit 1
            fi
        "
    end
end


template "/etc/yum.repos.d/atrpms-testing.repo" do
    mode "0644"
    source "atrpms-testing.repo"
end


yum_repo :atrpms do
    action :disable
end

yum_repo "atrpms-testing" do
    action :disable
end
