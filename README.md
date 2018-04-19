[![Build Status](https://travis-ci.org/MichaelAquilina/git-commands.svg?branch=master)](https://travis-ci.org/MichaelAquilina/git-commands)

Helper commands for git.

git-clean-branches
------------------

Cleans (delete) any branches that have been been merged into master. This should make
your life easier when figuring out which local branches are no longer important.

Installation:
place `git-clean-branches` into any directory which is in your `$PATH`

If you are using `zplug` on zsh then this can easily be done by adding the following to `~/.zshrc`

```
zplug "MichaelAquilina/git-commands", \
    as:command, \
    use:git-clean-branches
```

git-web
-------

Opens the relevant web page for the git repository. By default this opens the repository for
the "origin" remote.

Installation:
place `git-web` into any directory which is in your `$PATH`

If you are using `zplug` on zsh then this can easily be done by adding the following to `~/.zshrc`

```
zplug "MichaelAquilina/git-commands", \
    as:command, \
    use:git-web
```
