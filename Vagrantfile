DO_BOX_URL = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
PRIVATE_KEY_PATH = ENV["DIGITAL_OCEAN_PRIVATE_KEY_PATH"]
TOKEN = ENV["DIGITAL_OCEAN_PAT"]

Vagrant.configure("2") do |config|
  config.ssh.insert_key = false
  config.vm.define "droplet1" do |droplet|
    droplet.vm.provider :digital_ocean do |provider, override|
      override.ssh.private_key_path = PRIVATE_KEY_PATH
      override.vm.box = 'digital_ocean'
      override.vm.box_url = DO_BOX_URL
      override.nfs.functional = false
      override.vm.allowed_synced_folder_types = :rsync
      provider.token = TOKEN
      provider.image = 'ubuntu-22-04-x64'
      provider.region = 'fra1'
      provider.size = 's-1vcpu-1gb'
    end

    droplet.vm.provision "shell", privileged: false, inline: <<-SHELL
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
    SHELL
  end
end
