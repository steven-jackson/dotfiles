server="1013"
xcode_build_dir="/Users/steven/Library/Developer/Xcode/DerivedData/Defendpoint-fgbftiezftkbbebxeuagglvuyrtr/Build/Products/Debug"
qt_build_dir="/Users/steven/projects/build-Defendpoint"
target="/usr/local/libexec/Avecto/Defendpoint/1.0"

alias disable_debug_defendpoint_gui="ssh admin@$server launchctl unload -w /Library/LaunchAgents/com.avecto.defendpoint-gui-debug.plist"
alias disable_debug_defendpoint_daemon="ssh $server launchctl unload -w /Library/LaunchDaemons/com.avecto.defendpointd-debug.plist"
alias disable_debug_policy_daemon="ssh $server launchctl unload -w /Library/LaunchDaemons/com.avecto.dppolicyserverd-debug.plist"

alias enable_release_defendpoint_gui="ssh admin@$server launchctl load -w /Library/LaunchAgents/com.avecto.defendpoint.plist"
alias enable_release_defendpoint_daemon="ssh $server launchctl load -w /Library/LaunchDaemons/com.avecto.defendpointd.plist"
alias enable_release_policy_daemon="ssh $server launchctl load -w /Library/LaunchDaemons/com.avecto.dppolicyserverd.plist"

alias disable_release_defendpoint_gui="ssh admin@$server launchctl unload -w /Library/LaunchAgents/com.avecto.defendpoint.plist"
alias disable_release_defendpoint_daemon="ssh $server launchctl unload -w /Library/LaunchDaemons/com.avecto.defendpointd.plist"
alias disable_release_policy_daemon="ssh $server launchctl unload -w /Library/LaunchDaemons/com.avecto.dppolicyserverd.plist"

disable_release_daemons() {
    enable_release_defendpoint_gui
    enable_release_defendpoint_daemon
    enable_release_policy_daemon
}

enable_release_daemons() {
    disable_release_defendpoint_gui
    disable_release_defendpoint_daemon
    disable_release_policy_daemon
}

install_local_package() {
    scp "$xcode_build_dir/QT/Defendpoint_5.2.0.0.pkg" $server:/tmp
    ssh $server installer -pkg /tmp/Defendpoint_5.2.0.0.pkg -target /
}

install_defendpoint_gui() {
    disable_release_defendpoint_gui
    ssh $server mkdir -p "$target/Debug"
    rsync -r "$qt_build_dir/Defendpoint/Defendpointd.app/" "$server:$target/Debug/Defendpointd.app"
    echo "You should now manually start $target/Debug/Defendpointd.app/Contents/MacOS/Defendpointd"
#    enable_release_defendpoint_gui
}

install_policy_daemon() {
    disable_release_policy_daemon
    ssh $server mkdir -p "$target/Debug"
    rsync -r "$qt_build_dir/dppolicyserverd/dppolicyserverdd.app/" "$server:$target/Debug/dppolicyserverdd.app"
    ssh $server $target/Debug/dppolicyserverdd.app/Contents/MacOS/dppolicyserverdd
    ssh $server pkill -15 dppolicyserverdd
    enable_release_policy_daemon
}

replace_policy_daemon() {
    sudo rm -rf /Library/Security/SecurityAgentPlugins/dppolicyplugin.bundle
    sudo ln -s $xcode_build_dir/dppolicyplugin.bundle /Library/Security/SecurityAgentPlugins/
}

install_defendpoint_daemon() {
    disable_release_defendpoint_daemon
    ssh $server mkdir -p "$target/Debug"
    rsync -r "$qt_build_dir/defendpointd/defendpointdd.app/" "$server:$target/Debug/defendpointdd.app"
    ssh $server lldb $target/Debug/defendpointdd.app/Contents/MacOS/defendpointdd
    ssh $server pkill -15 defendpointdd
#    enable_release_defendpoint_daemon
}

allow_unsigned_kext() {
    ssh $server nvram boot-args=kext-dev-mode=1
    echo "The VM is restarting for the changes to take affect"
    #ssh $server reboot
}

# TODO: This looks like it restores the defaults for everything
disallow_unsigned_kext() {
    ssh $server nvram -d boot-args
}

install_kext() {
    local kext="FinderMonitor.kext"
    local id="com.beyondtrust.FinderMonitor"

    kextlibs "$src/$kext"
    kextutil -n "$src/$kext"

    rsync -r "$src/$kext" "$server:/tmp"
    ssh $server chown -R root:wheel "/tmp/$kext"
    ssh $server kextunload -b $id
    ssh $server kextload "/tmp/$kext"
}

install_policy_plugin() {
    ssh $server rm -rf /Library/Security/SecurityAgentPlugins/dppolicyplugin.bundle
    rsync -r $xcode_build_dir/dppolicyplugin.bundle $server:/Library/Security/SecurityAgentPlugins/
}

install_policy_plugin_locally() {
    sudo rm -rf /Library/Security/SecurityAgentPlugins/dppolicyplugin.bundle
    sudo rsync -r $xcode_build_dir/dppolicyplugin.bundle /Library/Security/SecurityAgentPlugins/
}

restore_policy_plugin() {
    ssh $server rm -rf /Library/Security/SecurityAgentPlugins/dppolicyplugin.bundle
    ssh $server cp -r $target/dppolicyplugin.bundle /Library/Security/SecurityAgentPlugins/
}

create_dmg() {
    hdiutil create -fs HFS+ -srcfolder "$1" -volname "$(basename $2)" "$2.dmg"
}

pm-daemon-status() {
    if ps aux | grep $target/defendpointd.app/Contents/MacOS/defendpointd > /dev/null; then
        defaults read $target/defendpointd.app/Contents/Info.plist CFBundleShortVersionString
    elif pgrep defendpointd; then
        echo "Developer"
    else
        echo "None"
    fi
}

pm-gui-status() {
    if ps aux | grep $target/PrivilegeManagement.app/Contents/MacOS/PrivilegeManagement > /dev/null; then
        defaults read /Applications/PrivilegeManagement.app/Contents/Info.plist CFBundleShortVersionString
    elif pgrep PrivilegeManagement; then
        echo "Developer"
    else
        echo "None"
    fi
}

pm-policy-daemon-status() {
    if ps aux | grep $target/dppolicyserverd.app/Contents/MacOS/dppolicyserverd > /dev/null; then
        defaults read $target/dppolicyserverd.app/Contents/Info.plist CFBundleShortVersionString
    elif pgrep dppolicyserverd; then
        echo "Developer"
    else
        echo "None"
    fi
}


pm-custodian-status() {
    if ps aux | grep $target/Custodian.app/Contents/MacOS/Custodian > /dev/null; then
        defaults read $target/dppolicyserverd.app/Contents/Info.plist CFBundleShortVersionString
    elif pgrep Custodian; then
        echo "Developer"
    else
        echo "None"
    fi
}

pm-sudo-status() {
    sudo -V | grep Avecto
}

pm-status() {
    echo "defendpointd:         $(pm-daemon-status)"
    echo "PrivilegeManagement:  $(pm-gui-status)"
    echo "dppolicyserverd:      $(pm-policy-daemon-status)"
    echo "Custodian:            $(pm-custodian-status)"
    echo "sudo:                 $(pm-sudo-status)"
    echo "$(csrutil status)"
    echo "$(spctl kext-consent status)"
    echo "$(spctl kext-consent list)"
}
