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
The environment variables `DIGITAL_OCEAN_PRIVATE_KEY_PATH` and `DIGITAL_OCEAN_PAT` are needed.
The first is the path to the authenticated private key, and the second is the API token.

Once the vm has been provisioned, the following is needed to deploy

Push local files using scp
`scp -i <private_key> -r <repository> root@67.205.156.216:/app/.`

SSH into machine
`vagrant ssh`

Inside the machine, build the image:
`docker build . -t minitwit`

Run the container detached with the repo mounted (to save changes in db)

`docker run -d -v $(pwd):/app -p 5000:5000 minitwit`

