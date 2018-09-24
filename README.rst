============
Git Commands
============


|CircleCI| |GPLv3|

Helper commands for git.

* git-web_
* git-clean-branches_

git-web
=======

Opens the relevant web page for the git repository. By default this opens the repository for
the "origin" remote.

Open up a web page for the default origin remote:

.. code:: shell

    git web

Open up web page for other specified remote:

.. code:: shell

    git web upstream

Open up the issues page:

.. code:: shell

    git web --issues

Open up all open pull requests:

.. code:: shell

    git web --pulls

Open new pull request for current branch:

.. code:: shell

    git web --pull-request

Installation
````````````

place ``git-web`` into any directory which is in your ``$PATH``

Alternatively, if you are using ``zplug`` on zsh then this can easily be done by adding
the following to ``~/.zshrc``:

.. code:: shell

    zplug "MichaelAquilina/git-commands", \
        as:command, \
        use:git-web


git-clean-branches
==================

Cleans (delete) any branches that have been been merged into master. This should make
your life easier when figuring out which local branches are no longer important.

Delete all local branches that have been merged into master:

.. code:: shell

    git clean-branches

Force delete any branches that might be in an inconistent state:

.. code:: shell

    git clean-branches -D

Installation
````````````

place ``git-clean-branches`` into any directory which is in your ``$PATH``

Alternatively, if you are using ``zplug`` on zsh then this can easily be done by adding
the following to ``~/.zshrc``:

.. code:: shell

    zplug "MichaelAquilina/git-commands", \
        as:command, \
        use:git-clean-branches


.. |CircleCI| image:: https://circleci.com/gh/MichaelAquilina/git-commands.svg?style=svg
   :target: https://circleci.com/gh/MichaelAquilina/git-commands

.. |GPLv3|  image:: https://img.shields.io/badge/License-GPL%20v3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0
