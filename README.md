vdash
=====

Rootstrikers volunteer dashboard


Local Setup
===========
Install Postgres, start psqld
createuser -h localhost -s vdash
bundle install
rake db:create db:migrate db:test:prepare

./script/rails server # to run dev server
autotest # to run tests


Deploying to Heroku
===================
To get set up:
brew install heroku-toolbelt # for OSX with brew
heroku login
cd vdash
heroku git:remote --app vdash # --app arg tells is the heroku app to link to

Then to deploy:
git push heroku master
