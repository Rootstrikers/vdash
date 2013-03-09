vdash
=====

Rootstrikers volunteer dashboard


Local Setup
=============
Install Postgres, start psqld
createuser -s vdash
rake db:create db:migrate db:test:prepare

To run tests: autotest