vdash
=====

Rootstrikers volunteer dashboard


Local Setup
=============
Install Postgres, start psqld
createuser -h localhost -s vdash
bundle install
rake db:create db:migrate db:test:prepare

./script/rails server # to run dev server
autotest # to run tests
