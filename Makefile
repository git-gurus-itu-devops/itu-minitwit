init:
	python -c"from minitwit import init_db; init_db()"

build:
	gcc flag_tool.c -l sqlite3 -o flag_tool

clean:
	rm flag_tool

test:
	cp ./db/minitwit_dev.db ./db/minitwit_test.db
	mkdir -p log
	APP_ENV=test nohup bundle exec ruby myapp.rb > ./log/test.log 2>&1 &
	sleep 2
	- pytest refactored_minitwit_tests.py -vvv
	pkill -f minitwit
	rm ./db/minitwit_test.*

test_api:
	cp ./db/minitwit_dev.db ./db/minitwit_test.db
	mkdir -p log
	APP_ENV=test nohup bundle exec ruby ./simapi/sim_api.rb > ./log/test.log 2>&1 &
	sleep 2
	- pytest minitwit_sim_api_test.py -vvv
	pkill -f itu-minitwit
	rm ./db/minitwit_test.*
