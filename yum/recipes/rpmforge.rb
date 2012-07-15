#
# Cookbook Name:: yum
# Recipe:: rpmforge
#
# Copyright 2012, Cogini
#
# All rights reserved - Do Not Redistribute
#

package_name = "rpmforge-release"

if node.platform_version.to_f >= 6 and node.platform_version.to_f < 7
    execute "rpmforge el6 64bit" do
        #64bit system
        command "rpm -i http://pkgs.repoforge.org/#{package_name}/#{package_name}-0.5.2-2.el6.rf.x86_64.rpm"
        only_if "
            if uname -m | grep 64 && (if rpm -q #{package_name}; then exit 1; else exit 0; fi)
            then exit 0
            else exit 1
            fi
        "
    end

    execute "rpmforge el6 32bit" do
        #32bit system
        command "rpm -i http://pkgs.repoforge.org/#{package_name}/#{package_name}-0.5.2-2.el6.rf.i386.rpm"
        only_if "
            if uname -m | grep -v 64 && (if rpm -q #{package_name}; then exit 1; else exit 0; fi)
            then exit 0
            else exit 1
            fi
        "
    end

elsif node.platform_version.to_f >= 5 and node.platform_version.to_f < 6
    execute "rpmforge el5 64bit" do
        #64bit system
        command "rpm -i http://pkgs.repoforge.org/#{package_name}/#{package_name}-0.5.1-1.el5.rf.x86_64.rpm"
        only_if "
            if uname -m | grep 64 && (if rpm -q #{package_name}; then exit 1; else exit 0; fi)
            then exit 0
            else exit 1
            fi
        "
    end

    execute "rpmforge el5 32bit" do
        #32bit system
        command "rpm -i http://pkgs.repoforge.org/#{package_name}/#{package_name}-0.5.2-2.el5.rf.i386.rpm"
        only_if "
            if uname -m | grep -v 64 && (if rpm -q #{package_name}; then exit 1; else exit 0; fi)
            then exit 0
            else exit 1
            fi
        "
    end
end
