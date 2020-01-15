Vagrant.configure("2") do |config|
    config.vm.box = "centos/7"
    
    # Do not check for updates - needs to be demoable
    config.vm.box_check_update = false

    # Forward Hadoop Ports
    config.vm.network "forwarded_port", guest: 50070, host: 50070
    config.vm.network "forwarded_port", guest: 9870, host: 9870
    config.vm.network "forwarded_port", guest: 9866, host: 9866
    config.vm.network "forwarded_port", guest: 9864, host: 9864
    config.vm.network "forwarded_port", guest: 50075, host: 50075
    config.vm.network "forwarded_port", guest: 50470, host: 50470
    config.vm.network "forwarded_port", guest: 8088, host: 8088
    config.vm.network "forwarded_port", guest: 8020, host: 8020
    config.vm.network "forwarded_port", guest: 9000, host: 9000
    config.vm.network "forwarded_port", guest: 50475, host: 50475
    config.vm.network "forwarded_port", guest: 50010, host: 50010
    config.vm.network "forwarded_port", guest: 50020, host: 50020
    config.vm.network "forwarded_port", guest: 50090, host: 50090

    # Set hostname
    config.vm.hostname = "vagrant-hadoop"

    config.vm.provision :shell, path: "resources/sys_update.sh"

    config.vm.provision "file", source:"~/XOM/etl_test_file-drop", destination: "/tmp/file-drop"

    # For vagrant, reload needs to be through provisioning service
    # Requires reload vagrant plugin
    config.vm.provision :reload

    # Install Hadoop
    config.vm.provision :shell, path: "resources/install_hadoop.sh"
end