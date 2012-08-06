BetterUserVoice
===============

Safari/Chrome browser extension that improves UserVoice Admin UI.


Installation
------------

[Get Chrome extension](https://chrome.google.com/webstore/detail/kjfhfgeliamlionedcemhchbpmimanem) / [Download Safari extension](http://files.tarantsov.com/BetterUserVoice/1.0.0/BetterUserVoice-1.0.0.safariextz)


Features
--------

Currently, BetterUserVoice adds:

* checkboxes for selecting multiple tickets
* bulk mark-as-spam command to the gears menu

![Screenshot of Bulk Mark As Spam](http://files.tarantsov.com/BetterUserVoice/assets/BetterUserVoice-bulk-mark-as-spam.png)


Hacking
-------

Install Stylus and IcedCoffeeScript by running:

    npm install

Then you can use:

    rake           # Build *.{js,css} from src/*.{iced,styl}

    rake clean     # Remove any temporary products.
    rake clobber   # Remove any generated file.

    rake version   # Embed version number from VERSION

    rake tag       # Tag the current version
    rake retag     # Move (git tag -f) the tag for the current version

    rake dist      # Upload Safari extension, zip and upload Chrome extension
    rake manifest  # Upload Safari update manifest

Tested with Node.js 0.8 and Ruby 1.8.7.
