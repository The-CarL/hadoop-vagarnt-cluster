Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"
    
    # Do not check for updates - needs to be demoable
    config.vm.box_check_update = false

    # Public Network - WARNING, if on insecure network, this can be dangerous
    config.vm.network "public_network", bridge: "en0: Wi-Fi (Wireless)"

    # Set hostname
    config.vm.hostname = "vagrant-hadoop"

    config.vm.provision :shell, path: "resources/sys_update.sh"

    # For vagrant, reload needs to be through provisioning service
    # Requires reload vagrant plugin
    config.vm.provision :reload
end