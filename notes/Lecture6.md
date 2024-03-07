# Lecture 6

## Preparation tasks

* CPU load during the last hour/the last day.
    * Log in to digital ocean and navigate to droplet
    * Select Graphs tab
    * Select period 1 hour / 24 hours
    * Hover over the CPU % graph to see specific numbers
        * Max-load last hour: 2.30%
        * Max-load last day: 4.82% (during last restart of VM)
* Average response time of your application's front page.
    * Open developer tools in your browser and navigate to "Network" tab
    * Navigate to URL (http://165.227.245.161:5000/public)
    * Find the entry in your developer tools named `public`
    * Open "Timing" tab
        * Initial connection: 81.91ms
        * Waiting for server response: 126.79ms
        * Content Download: 2.50ms
        * Total time (including other sub-tasks): 216.60ms
* Amount of users registered in your system.
    * ssh into droplet as root user
    * Realize that we use managed DB now and DB is not in droplet anymore
    * Download psql in WSL (`sudo apt install postgresql postgresql-contrib`)
    * In DigitalOcean, find the managed database
    * Select "Connection string" instead of "Connection parameters", select correct database and user and click copy
    * Stall
    * In Digital Ocean, add your IP to trusted sources (suggested in dropdown when clicking)
    * `select count(*) from users;` = 9240
* Average amount of followers a user has.
    * Same connection steps as above
    * Google division in postgresql
    * Google subqueries in division in postgresql
    * See below query:
        ```sql
        select
            (select count(f.*) from followers f) /
            (select count(u.*) from users u) 
        as result;
        ```
    * Gives rounded value `2` as result
    * Google postgres integers division return float
    * See below query:
        ```sql
        select
            (select count(f.*) from followers f) ::numeric /
            (select count(u.*) from users u) 
        as result;
        ```
    * Result:  2.2254023112647154
