# README

This is a guideline for dealing with .dotfiles on my machines.

## Initial setup

First, we create repositry on GitHub. Next, we clone this repositor:
```
git clone --bare https://github.com/akastrin/dotfiles.git $HOME/.dotfiles
```

We will create an alias for running git commands in `.dotfiles` repository:
```
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

We can add created alis to `.bashrc` file but this is not necessary. from now on, any git operation in the `.dotfiles` repository can be done by the `dotfiles` alias. Now let's set status to not show untracked:
```
dotfiles config --local status.showUntrackedFiles no
```

Now we can config files, commit and push. For example:
```
dotfiles add .emacs.d/init.el
dotfiles commit -m "Add init.el file"
dotfiles push --set-upstream origin master
```
