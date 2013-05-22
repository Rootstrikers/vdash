vdash
=====

Rootstrikers volunteer dashboard


Local Setup
===========
Install Postgres, start psqld. On OSX, http://postgresapp.com/ is an easy way to do this.

Then:
```
createuser -h localhost -s vdash
bundle install
rake db:create db:migrate db:test:prepare

./script/rails server # to run dev server
autotest # to run tests
```


Deploying to Shared Heroku
==========================
To get set up:
```
brew install heroku-toolbelt # for OSX with brew
heroku login
cd vdash
heroku git:remote --app vdash # --app arg tells is the heroku app to link to
```

Then to deploy:
```
git push heroku master
heroku run rake db:migrate
```

If you need to make yourself an admin:
```
heroku run rails c
User.find_by_name('your_name').update_attribute(:admin, true)
```

Deploying to Personal Heroku
============================

If you get:
```
$ heroku git:remote --app vdash
!    You do not have access to the app vdash.
```

or if you want to have your own personal Heroku instance, do the following.

Assuming your nickname is foo...

```
$ cd vdash
$ heroku create vdash-foo
$ git push heroku master
$ heroku run rake db:migrate
```

Your instance is available at http://vdash-foo.heroku.com

Setup Twitter Auth
------------------

Your vdash-foo app isn't setup for any Social Auth, let's fix that.

1. Create a [new Twitter App](https://dev.twitter.com/apps/new)
2. Callback URL would be `http://vdash-foo.heroku.com/oauth/authenticate` (replace vdash-foo).
3. Click Create Twitter Application button
4. **Go back and enable** "Sign in with Twitter" by "editing" the app.
5. From the command line, provide your Consumer Key and Consumer Secret

```
$ heroku config:set TWITTER_API_KEY=L8AsSomeLongStringFVg TWITTER_API_SECRET=qqxx9eAnotherBigOne8TUgBcZA0cvf5U
Setting config vars and restarting vdash-foo... done, v7
TWITTER_API_KEY:    L8AsSomeLongStringFVg
TWITTER_API_SECRET: qqxx9eAnotherBigOne8TUgBcZA0cvf5U
```

If you're developing locally, add these environment variables to your .bashrc / .zshrc:

```
export TWITTER_API_KEY='L8AsSomeLongStringFVg'
export TWITTER_API_SECRET='qqxx9eAnotherBigOne8TUgBcZA0cvf5U'
```

You'll have to `source ~/.bashrc` and then restart your server.

You should now be able to use Twitter to sign into your personal vdash instance.
