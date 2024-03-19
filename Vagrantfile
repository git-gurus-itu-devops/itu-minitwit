DO_BOX_URL = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
PRIVATE_KEY_PATH = ENV["DIGITAL_OCEAN_PRIVATE_KEY_PATH"]
TOKEN = ENV["DIGITAL_OCEAN_PAT"]
SSH_KEY_NAME = ENV["SSH_KEY_NAME"]

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.ssh.private_key_path = PRIVATE_KEY_PATH
  config.vm.synced_folder "./remote_files", "/minitwit", type: "rsync"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # mount synced folder to vm
  config.vm.define "droplet1" do |droplet1|
    droplet1.vm.provider :digital_ocean do |provider, override|
      override.vm.box = 'digital_ocean'
      override.vm.box_url = DO_BOX_URL
      override.nfs.functional = false
      provider.ssh_key_name = SSH_KEY_NAME
      provider.token = TOKEN
      provider.image = 'ubuntu-22-04-x64'
      provider.region = 'fra1'
      provider.size = 's-1vcpu-1gb'
    end

    droplet1.vm.provision "shell", privileged: false, inline: <<-SHELL
      echo 'Installing Docker'

      # Add Docker's official GPG key:
      sudo apt-get update
      sudo apt-get install -y ca-certificates curl
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      # Add the repository to Apt sources:
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update

      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

      echo 'Finished installing Docker'

      sudo ssh-import-id-gh duckth
      sudo ssh-import-id-gh A-Guldborg
      sudo ssh-import-id-gh fredpetersen
      sudo ssh-import-id-gh silkeholmebonnen
      sudo ssh-import-id-gh MadsRoager

      cd /minitwit

      chmod +x ./deploy.sh
    SHELL
  end

  config.vm.define "staging" do |staging|
    staging.vm.provider :digital_ocean do |provider, override|
      override.vm.box = 'digital_ocean'
      override.vm.box_url = DO_BOX_URL
      override.nfs.functional = false
      provider.ssh_key_name = SSH_KEY_NAME
      provider.token = TOKEN
      provider.image = 'ubuntu-22-04-x64'
      provider.region = 'fra1'
      provider.size = 's-1vcpu-1gb'
    end

    staging.vm.provision "shell", privileged: false, inline: <<-SHELL
      echo 'Installing Docker'

      # Add Docker's official GPG key:
      sudo apt-get update
      sudo apt-get install -y ca-certificates curl
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      # Add the repository to Apt sources:
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update

      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

      echo 'Finished installing Docker'

      cd /minitwit

      chmod +x ./deploy.sh
    SHELL
  end
end
