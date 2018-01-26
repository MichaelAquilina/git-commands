Helper command for git.

Cleans (delete) any branches that have been been merged into master. This should make
your life easier when figuring out which local branches are no longer important.

Installation:
place `git-clean-branches` into any directory which is your `$PATH`

If you are using `zplug` on zsh then this can easily be done by adding the following to `~/.zshrc`

```
zplug "MichaelAquilina/git-clean-branches", \
    as:command, \
    use:git-clean-branches
```
