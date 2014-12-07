pivotal-to-trello [![Build Status](https://travis-ci.org/recurser/pivotal-to-trello.png?branch=master)](https://travis-ci.org/recurser/pivotal-to-trello)
=================

This repo provides a command for exporting a [Pivotal Tracker](https://www.pivotaltracker.com/) project to [Trello](https://trello.com/). The command is available as a gem or a docker container.

Getting started
---------------

1. Install the gem:

        > gem install pivotal-to-trello

   Or pull the container down using Docker:

        > docker pull kennethkalmer/pivotal-to-trello

   When using the docker container, substitute every occurance of `pivotal-to-tracker` with `sudo docker run -a -i kennethkalmer/pivotal-to-tracker`

2. Run the importer:

        > pivotal-to-trello import --trello-key TRELLO_API_KEY --trello-token TRELLO_TOKEN --pivotal-token PIVOTAL_TOKEN

  See the [Obtaining API credentials](#obtaining-api-credentials) section for details on how to obtain these credentials.

  The importer will ask you a series of questions to identify which Trello lists you want to import certain classes of stories into. It will then import the stories into Trello, along with any associated comments. It does not currently have the ability to import attachments.

  For example :

        > pivotal-to-trello import --trello-key TRELLO_API_KEY --trello-token TRELLO_TOKEN --pivotal-token PIVOTAL_TOKEN

        Which Pivotal project would you like to export?
        1. Android App
        2. IOS App
        3. Tech Support
        4. Web App
        Please select an option : 4

        Which Trello board would you like to import into?
        1. Development
        2. Welcome Board
        3. Wish List
        Please select an option : 1

        Which Trello list would you like to put 'icebox' stories into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 6

        Which Trello list would you like to put 'current' stories into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 7

        Which Trello list would you like to put 'finished' stories into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 5

        Which Trello list would you like to put 'delivered' stories into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 4

        Which Trello list would you like to put 'accepted' stories into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 10

        Which Trello list would you like to put 'rejected' stories into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 10

        Which Trello list would you like to put 'backlog' bugs into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 2

        Which Trello list would you like to put 'backlog' chores into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 2

        Which Trello list would you like to put 'backlog' features into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 2

        Which Trello list would you like to put 'backlog' releases into?
        1. Accepted
        2. Backlog
        3. Bugs
        4. Delivered
        5. Finished
        6. Icebox
        7. In Progress
        8. Rejected
        9. Releases
        10. [don't import these stories]
        Please select an option : 2

        What color would you like to label bugs with?
        1. Blue
        2. Green
        3. Orange
        4. Purple
        5. Red
        6. Yellow
        7. [none]
        Please select an option : 5

        What color would you like to label features with?
        1. Blue
        2. Green
        3. Orange
        4. Purple
        5. Red
        6. Yellow
        7. [none]
        Please select an option : 2

        What color would you like to label chores with?
        1. Blue
        2. Green
        3. Orange
        4. Purple
        5. Red
        6. Yellow
        7. [none]
        Please select an option : 6

        What color would you like to label releases with?
        1. Blue
        2. Green
        3. Orange
        4. Purple
        5. Red
        6. Yellow
        7. [none]
        Please select an option : 4

        Beginning import...
        Creating a card for chore 'My example chore'.
        ...

Obtaining API credentials
-------------------------

You can get your Trello application key by logging into Trello, and then visiting [https://trello.com/1/appKey/generate](https://trello.com/1/appKey/generate)

Your 32-character application key will be listed in the first box.

To obtain your Trello member token, visit the following URL, substuting your Trello application key for *APP_KEY*:

[https://trello.com/1/authorize?key=APP_KEY&name=Pivotal%20To%20Trello&response_type=token&scope=read,write](https://trello.com/1/authorize?key=APP_KEY&name=Pivotal%20To%20Trello&response_type=token&scope=read,write)

Click the *Allow* button, and you will be presented with a 64-character token.

See the [Trello documentation](https://trello.com/docs/gettingstarted/index.html#getting-an-application-key) for more details.

The Pivotal Tracker token can be found at the bottom of your [Pivotal profile page](https://www.pivotaltracker.com/profile).

Change history
--------------

* **Version 0.1.0 (2014-01-13)** : Initial version.

Bug Reports
-----------

If you come across any problems, please [create a ticket](https://github.com/recurser/pivotal-to-trello/issues) and I'll try to get it fixed as soon as possible.

Contributing
------------

Once you've made your changes:

1. [Fork](http://help.github.com/fork-a-repo/) pivotal-to-trello
2. Create a topic branch - `git checkout -b my_branch`
3. Push to your branch - `git push origin my_branch`
4. Create a [Pull Request](http://help.github.com/pull-requests/) from your branch
5. That's it!


Author
------

Dave Perrett :: hello@daveperrett.com :: [@daveperrett](http://twitter.com/daveperrett)


Copyright
---------

Copyright (c) 2014 Dave Perrett. See [License](https://github.com/recurser/jquery-i18n/blob/master/LICENSE) for details.
