init:
	python -c"from minitwit import init_db; init_db()"

build:
	gcc flag_tool.c -l sqlite3 -o flag_tool

clean:
	rm flag_tool

test_e2e:
	APP_ENV=test bundle exec rake db:create
	APP_ENV=test bundle exec rake db:migrate
	APP_ENV=test bundle exec rake db:seed
	mkdir -p log
	APP_ENV=test nohup bundle exec ruby myapp.rb > ./log/test.log 2>&1 &
	sleep 2
	- yarn playwright test
	pkill -f minitwit
	APP_ENV=test bundle exec rake db:drop

test:
	APP_ENV=test bundle exec rake db:create
	APP_ENV=test bundle exec rake db:migrate
	mkdir -p log
	APP_ENV=test nohup bundle exec ruby myapp.rb > ./log/test.log 2>&1 &
	sleep 2
	- pytest refactored_minitwit_tests.py -vvv
	pkill -f minitwit
	APP_ENV=test bundle exec rake db:drop

test_api:
	APP_ENV=test bundle exec rake db:create
	APP_ENV=test bundle exec rake db:migrate
	mkdir -p log
	APP_ENV=test nohup bundle exec ruby ./simapi/sim_api.rb > ./log/test.log 2>&1 &
	sleep 2
	- pytest ./simapi/minitwit_sim_api_test.py -vvv
	pkill -f minitwit
	APP_ENV=test bundle exec rake db:drop
