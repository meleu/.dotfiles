# homedir

Why versioning only dotfiles if we can do the same with our homedir?

## smart way to manage your dotfiles

### starting a dotfiles repo

```bash
# create your configs dir
cd ~
mkdir dotfiles

# start a git repo
cd ~/dotfiles
git init

# create a git repository for you and get the url
git remote add origin git@github.com:${USERNAME}/${REPO_NAME}.git

# tell git that your worktree starts in your $HOME
git config core.worktree '../../'

# ignore everything
echo '*' > ../.gitignore

# once you're ignoring everything, the only way
# to add files is by using The Force™️
git add -f ../.bashrc
git add -f ../.bash_profile
git add -f ../.vimrc
# etc...

# commit your changes to the remote repo
git commit -m "Initial commit"
git push
```


### getting your dotfiles on a new machine

```bash
# go to your home dir
cd ~

# clone the repo with the "--no-checkout" option
# (so we can checkout the files in our homedir)
git clone --no-checkout git@github.com:${USERNAME}/${REPO_NAME}.git

# go to the created directory and do the wortree trick
cd ${REPO_NAME}
git config core.worktree '../../'

# checkout your files overwriting the existing ones
git reset --hard origin/master
```


### notes about gitignoring everything

- Remember: your `.gitignore` is ignoring "everything" with that `*`
- Anything you want to add must be done with `git add -f`
- Your `git` commands will only work while you're in the `~/${REPO_NAME}` directory, so if you want to add a new file, you need to `git add -f ../${FILENAME}`
- Once a file was added to the list of tracked files, you don't need to use `-f` for that file anymore.

### inspiration

- worktree trick: <https://www.wangzerui.com/2017/03/06/using-git-to-manage-system-configuration-files/>
- gitignoring everything: <https://drewdevault.com/2019/12/30/dotfiles.html>
