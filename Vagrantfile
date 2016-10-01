# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.define "falu" do |dev|
    dev.vm.provider "virtualbox" do |virtualbox|
      virtualbox.name = "falu-development"
    end
    dev.vm.box = "bento/ubuntu-14.04"
    dev.vm.hostname = "falu-development"
    dev.vm.provision "docker"
  end

end
