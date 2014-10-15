#!/bin/bash

# Script for updating MYSTU Learning (edX)

##### Functions

usage ()
{
    echo Usage: $(tput setaf 2)$(tput bold)$0 update$(tput sgr 0) or $(tput setaf 2)$(tput bold)$0 reset$(tput sgr 0)
}   # end of usage

important_message ()
{
    echo 
    echo $(tput setaf 2)$(tput bold)$1$(tput sgr 0)
}   # end of important_message

update_theme_svn ()
{
    important_message "Updating theme svn..."

    cd /edx/app/edxapp/themes/mystu
    sudo -H -u edxapp svn update
}   # end of update_theme_svn

update_cms_assets ()
{
    important_message "Updating CMS assets..."

    cd /edx/app/edxapp/edx-platform
    sudo -u edxapp LANG="en_US.UTF-8" SKIP_WS_MIGRATIONS="1" GEM_PATH="/edx/app/edxapp/.gem" NO_PREREQ_INSTALL="1" PATH="/edx/app/edxapp/venvs/edxapp/bin:/edx/app/edxapp/edx-platform/bin:/edx/app/edxapp/.rbenv/bin:/edx/app/edxapp/.rbenv/shims:/edx/app/edxapp/.gem/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" GEM_HOME="/edx/app/edxapp/.gem" RBENV_ROOT="/edx/app/edxapp/.rbenv" /edx/app/edxapp/venvs/edxapp/bin/paver update_assets cms --settings=aws
    cd ~
}   # end of update_cms_assets

update_lms_assets ()
{
    important_message "Updating LMS assets..."
        
    cd /edx/app/edxapp/edx-platform
    sudo -u edxapp LANG="en_US.UTF-8" SKIP_WS_MIGRATIONS="1" GEM_PATH="/edx/app/edxapp/.gem" NO_PREREQ_INSTALL="1" PATH="/edx/app/edxapp/venvs/edxapp/bin:/edx/app/edxapp/edx-platform/bin:/edx/app/edxapp/.rbenv/bin:/edx/app/edxapp/.rbenv/shims:/edx/app/edxapp/.gem/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" GEM_HOME="/edx/app/edxapp/.gem" RBENV_ROOT="/edx/app/edxapp/.rbenv" /edx/app/edxapp/venvs/edxapp/bin/paver update_assets lms --settings=aws
    cd ~
}   # end of update_lms_assets

restart_edxapp ()
{
    important_message "Restarting edxapp..."

    sudo /edx/bin/supervisorctl -c /edx/etc/supervisord.conf restart edxapp:
}   #end of restart_edxapp


##### Main

update_cms=
update_lms=

if [ "$1" != "" ]; then
    case $1 in
        update | --update )   update_lms=1
                              ;;
        reset | --reset )     update_cms=1
                              update_lms=1
                              ;;
        -h | help | --help )  usage
                              exit
                              ;;
        * )                   usage
                              exit 1
    esac
else
    update_lms=1
fi

update_theme_svn
if [ "$update_cms" = "1" ]; then
    update_cms_assets
fi
if [ "$update_lms" = "1" ]; then
    update_lms_assets
fi
restart_edxapp

important_message "Finished edX update."
echo $(tput setaf 4)Please enjoy.$(tput sgr 0)   - MYSTU Team
