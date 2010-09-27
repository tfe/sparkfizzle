[sparkfizzle](http://github.com/tfe/sparkfizzle/)
========

A quick and dirty script for piping tweets into Campfire. Follow individual Twitter accounts and monitor the tweet stream for certain terms.

The name is a play on [Sparkflare](https://sparkflare.com/), which stopped being free a couple months ago.  So I made my own with a fraction of the features.


Usage
-----

The script has dependencies on the broach and tweetstream gems. If you try to run it without them, it'll let you know.

Configuration is done by providing the path to a YAML config file as the last argument when calling this script. An example YAML config is provided. Just fill in your own Twitter and Campfire credentials, the Campfire room you'd like tweets to be posted to, and the Twitter IDs and track terms you'd like to follow.

Then just:

    ruby sparkfizzle.rb /path/to/my_sweet_config.yml

Logs will be output to `sparkfizzle_my_sweet_config.log` in the directory you run it from.


Todo
----

* I'm not sure what happens if you only want to track some terms OR follow some IDs, not do both at the same time. Handle that case.
* Allow usage of SSL for Campfire accounts that support it (broach's `use_ssl` config setting).

Contact
-------

Problems, comments, and pull requests all welcome. [Find me on GitHub.](http://github.com/tfe/)


Copyright
-------

Copyright © 2010 [Todd Eichel](http://toddeichel.com/) for [Fooala, Inc.](http://opensource.fooala.com/).
