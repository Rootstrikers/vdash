Rootstrikers Volunteer Dashboard (Currently running at http://vdash.rootstrikers.org)
=====

Overview and Design Goals
=====
Rootstrikers devotes staff and volunteer time to the management, development, and integration of the software tools necessary to implement its vision of providing the tools necessary to develop and run a plausible, modern, data-driven, grass-roots advocacy campaign dedicated to building a system for publicly funded elections in the United States.

Definitions
=====
Campaign: An organized series of activities that influence the decision making process of the public and branches of the government.
Plausible campaign: A plausible campaign has a reasonable chance of success of both altering public opinion and enacting policy changes which result in publicly funded elections.
Modern campaign: A modern campaign takes place in the public sphere and utilizes the best principles of social and information science to accomplish its goals.
Data-driven campaign: A data-driven campaign adapts principles of social science to continually adapt its strategies, services, organizational methods, and programming in response to what it is capable of learning from its prior activities.
Grass-roots campaign: Although initiated by a semi-centralized organization, a public election campaign's strategies, services, and methods must be defined and dependent on its own membership. In practice, this means adapting strategy and services not only to the data and needs, but also to the desires of the community.

Problem Statement
=====
The information technology required to support Rootstrikers vision is currently non-existent, fragmented, and/or non-free (as in speech).

Solution
=====
The Rootstrikers volunteer dashboard is an effort to develop and, where possible, integrate the information technology necessary to support the vision of a plausible, modern, data-driven, grass-roots advocacy campaign.

Strategy
=====
In order to both sway public opinion and enact policy changes, it is necessary to:
1. Build the broadest coalition possible;
2. Support diverse organizations and strategies which are in agreement with Rootstrikers core vision; and
3. Endorse our own vision by remaining transparent, free (as in speech), and community driven.

Approach
=====
The basic idea is to build an activity-centric website to recruit, assign, enable, mobilize, track, and evaluate volunteers as they participate on campaigns created within the dashboard.  This is not an attempt to make a progressive version of Facebook. Facebook is a social network. This is an attempt to make an activity-centric network with some limited social features.

Campaign Activity Modules
=====
Below is an initial list of potential campaign activity modules. This list is expected to grow and should be prioritized based on multiple evaluation metrics (outlined in the next section).

1. Sign an online petition
2. Participate in social media (author, retweet/repost/reshare, etc) [in progress]
3. Create or edit some informational campaign resources
4. Curate or edit some data set (e.g. coordinated edits of wikipedia, de-duplicate donor lists, etc)
5. Place a phone call to a target (with transcript, recording capabilities, ability to describe the outcome)
6. Organize a meetup
7. Recruit x friends
8. Respond to a survey or poll
9. Show up at a time/place to conduct an activity (e.g. observe voting practices/advise those who are being intimidated)
10. Canvas
11. Write a letter/fax/email to a target
12. Raise money
13. Contribute to a software project
14. ...others?

Campaign Activity Module Prioritization Metrics
======
We will develop campaign activities when the we have community support for the activity, defined as:
1. One or more campaign champion who will outline the requirements and strategy;
2. An individual or organization willing to run an initial campaign for which to develop the initial software;
3. Sufficient volunteer software development support or raised money to hire developers to create a minimum viable product.

Key Assumptions when developing a campaign activity module
=====
Participation in any campaign will vary.
1. Different solutions are necessary for different orders of magnitude of participants. That is, solutions for 10 don't necessarily scale to 100. 100 to 1000, … etc. Rootstrikers currently has tens of thousands supporters.  We can reasonable assume that ~1-3% will be active participants in any given project, resulting in ~500-1500 participants that need to be supported.  We obviously hope to grow these numbers, but don't necessarily need to be ready for 1 million participants tomorrow.
2. These participants have differing skills, levels of motivation, amount of time, and locations.
3. We assume that they are globally distributed but mostly based in the US. 
4. We assume that they are all familiar with the basics of email, search, and social media.  
5. We assume that levels of motivation and skills vary dramatically

Campaign Strategy
=====
Given the need for adaptability, the dashboard must remain strategy-agnostic for the following reasons:
1. Rootstrikers strategies will need to change over time to respond to a changing political climate.  
2. Most campaigns can be abstracted to reusable components. For example, the topic under discussion during door to door canvassing is rarely relevant to the method used to assign volunteers to streets. 
3. Our project will be more likely to be used by others and contributed back to by the open-source community. The more specific it is to Rootstrikers, the less likely this is to happen.
4. The creation or addition of additional campaigns will be much easier.
5. Others?

Interaction Model
=====
Given that we want to maximize participation, the exact number of people who will be available is always unknown.  That means there should be an abundance of tasks displayed in a way that doesn't make it look like a place where there's an infinite amount of work to do that can never be done. This means goal-oriented tasks, good tracking of progress, and motivational design.

Participants should be able to find tasks suited to their skills, time, and interest whenever and wherever they are. That means mobile participation, a facebook app, a stand-alone website, and possibly even sms-participation.  We don't need all tasks on all platforms, but need ones that make sense.

We will follow a blended push/pull model. When necessary, we can softly push tasks to appropriate participants. More generally, the philosophy is to allow the volunteers to pull tasks that interest them.

Interorganizational Features
=====
The dashboard should be an interorganizational software application roughly following the disaspora model (http://en.wikipedia.org/wiki/Diaspora_(software)). That is, each organization will have its own page/portion of the website to which they could recruit their own volunteers and post their own tasks. Volunteers could subscribe to multiple organizations, and organizations could belong to coalitions. For example, fight for the future, united republic, and Rootstrikers could all belong to a loose and unofficial coalition that aims to conduct campaign finance reform campaigns.  Volunteers could also subscribe to individual campaigns or task types.  For example, if a volunteer is really excited about wikipedia, they could subscribe to all wikipedia editing task types, regardless of which organization, coalition, or campaign posted the task.  Limited social features are required to enable a sense of community.

Social Features
=====
Volunteers should be able to link their social media profiles and send messages to each other.  Additionally, for those who opt-in, we can enable a 'Find Rootstrikers' in my area type of feature. Other social features may be built into specific campaign activities, such as the “organize a meetup” activity.

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
