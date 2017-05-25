The only rule of thumb: **Anything in the master branch is deployable**

## Workflow example

To work on some new feature/bugfix create a descriptively named branch off of master.

1. Create your working branch and jump to it

   On this branch I'm going to work with flume templates, so I've named it "flume-service"

   ```
   $ git checkout -b flume-service

   # This is shorthand for:
   #  git branch flume-service
   #  git checkout flume-service
   ```

2. Push your brand new branch to the remote server:

   ```
   $ git push -u origin flume-service
   ```

3. Push your commits to your named branches on the server constantly. Since the
  only thing we really have to worry about is master from a deployment
  standpoint, pushing to the server doesn’t mess anyone up or confuse things.

4. When you need feedback or help, or you think the branch is ready for merging,
  open a pull request.

5. If master branch has changes and you want work with this updates changes in
  your working branch you can merget the changes FROM master to your working branch:

```
$ git checkout flume-service
$ git merge master
```

## Tips

### Check diffs before commit within the $EDITOR
```
$ git commit -v
```

### TODO list about current works

A simple ‘git fetch’ will basically give you a TODO list of what every is currently working on:

```
$ git fetch --all
```
It also lets everyone see, by looking at the GitHub Branch List page, what
everyone else is working on so they can inspect them and see if they want to
help with something.

### Delete local branch and remote branch:

```
local branch: git branch -d fix_flume_dockerfile
remote branch: git push origin --delete fix_flume_dockerfile
```

### Remove all your local branches which are remotely deleted.
```
$ git fetch -p
```
you can set this automatically

```
git config fetch.prune true
or
git config --global fetch.prune true
```

### Get just one file from another branch
```
git checkout targetbranch
git checkout master -- filefrommaster
```
This command make a checkout of filefromaster file to targetbranch.

### Create local branch from an already created remote branch:
```
git checkout -b blueprints origin/blueprints
```
### Keeping a fork up to date with original repo

1. Clone your fork:

```
    git clone git@github.com:YOUR-USERNAME/YOUR-FORKED-REPO.git
```

2. Add remote from original repository in your forked repository: 

```
    cd into/cloned/fork-repo
    git remote add upstream git://github.com/ORIGINAL-DEV-USERNAME/REPO-YOU-FORKED-FROM.git
    git fetch upstream
```

3. Updating your fork from original repo to keep up with their changes:

```
    git pull upstream master
```

References:
* GitHub workflow: https://help.github.com/articles/what-is-a-good-git-workflow/
