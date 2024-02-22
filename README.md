# itu-minitwit

## Ruby setup guide

Requires Ruby 3.3.0 and Bundler

### Setup

- Install required gems with `bundle install`
- Initial database with `./control.sh init`
- Run migrations `bundle exec rake db:migrate`
- Start the app with `bundle exec ruby myapp.rb`


### Run tests

Run tests with `make test`
App cannot run while testing

### Run Dockerfile

Build the Dockerfile
```
docker build . -t minitwit
```

Run

```
docker run --rm -v /tmp:/tmp -it -p 5000:5000 minitwit [cmd]
```

The volume mount should point to the local database.
If `<cmd>` is not supplied, will run the app


### VM Provisioning & Deployment 

Virtual Machine provisioning is handled by Vagrant in DigitalOcean.
Run provisioning with `vagrant up`
The environment variables `DIGITAL_OCEAN_PRIVATE_KEY_PATH`, `SSH_KEY_NAME` and `DIGITAL_OCEAN_PAT` are needed.
The first is the path to the authenticated private key, the second is the name of your SSH key for Digital Ocean and the third is the authenticated token for the team

The Vagrantfile syncs the local repository to the VM so be sure to have a database in `db/minitwit.db`

The API will be available at http://165.227.245.161:5001

The interface will be available at http://165.227.245.161:5000
