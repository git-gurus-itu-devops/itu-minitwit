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

