init:
	python -c"from minitwit import init_db; init_db()"

build:
	gcc flag_tool.c -l sqlite3 -o flag_tool

clean:
	rm flag_tool

test:
	cp /tmp/minitwit.db /tmp/minitwit_test.db
	APP_ENV=test nohup bundle exec ruby myapp.rb > ./log/test.log 2>&1 &
	sleep 2
	- pytest refactored_minitwit_tests.py
	pkill -f minitwit
	rm /tmp/minitwit_test.db
