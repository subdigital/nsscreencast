# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 8000, host: 8082
  config.ssh.pty = true
  config.vm.synced_folder ".", "/srv/hello-world"
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y git clang libicu-dev nginx

    if [[ ! -f swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu14.04.tar.gz ]]
    then
      wget https://swift.org/builds/development/ubuntu1404/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu14.04.tar.gz
      tar xzvf swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu14.04.tar.gz
    fi

    echo "export PATH=/home/vagrant/swift-DEVELOPMENT-SNAPSHOT-2016-03-01-a-ubuntu14.04/usr/bin:$PATH" >> ~/.profile
    source ~/.profile

    swift --version
    sudo chown vagrant:vagrant /srv/hello-world
  SHELL
end
