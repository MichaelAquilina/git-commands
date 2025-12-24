============
Git Commands
============


|CircleCI| |GPLv3|

Helper commands for git.

* git-web_
* git-clean-branches_
* git-default-branch_

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

Open commit history

.. code:: shell

   git web --commits


Configution
```````````

``git config web.opencommand``: Set the command to use when opening urls by setting

``git config web.default.pulls``: Default fallback url path to use for pull requests

``git config web.default.issues``: Default fallback url path to use for issues

``git config web.default.commits``: Default fallback url path to use for commits

``git config web.$DOMAIN.pulls``: Path to use for pull requests for ``$DOMAIN``

``git config web.$DOMAIN.issues``: Path to use for issues for ``$DOMAIN``

``git cofnig web.$DOMAIN.commits``: Path to use for commit history for ``$DOMAIN``

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


git-default-branch
==================

Prints out the default branch of the repository (typically main or master) by querying
the HEAD of the origin remote.

This is a useful command to have when used in combination with other functions and aliases
you might have.

For example, the alias below would fail on any repositories which do not use main as the
default branch.

.. code:: shell

    alias grim="git rebase -i main"

However we can change this to use `git-default-branch` to make it work for any repository:

.. code:: shell

    alias grim="git rebase -i $$(git default-branch)"

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
