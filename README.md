## autogit
`autogit` is a tool to automatically synchronize projects via git. The `autpogit` utility itself is the
tool to manage projects to synch. It can add, list, and remove projects to synch. During boot the
specified projects remote is fetched and if the remote is ahead of the local repository `autogit`
will pull the changes into the local repository. Before shutdown `autogit` will check every
repository for uncommitted or unpushed changes and will commit and/or push them to the remote. With
this a project is automatically synchronized without the user having to do `git pull/push` actions by
hand.

### Installation
The `install` script will enable the systemd target, establish the log repository and create the
hook for all the systemd units for the single projects. Additionally the `autogit` utility will be
installed in `usr/local/bin/autogit` as a symbolic link.

### Usage
Use `autogit help` for a help page on the `autogit` utility.

__NOTE:__ All software uses the `$HOME` environment variable for determining directory paths. This
may result in unexpected behavior if users are often switched.

### Uninstall
The `uninstall` script will result in all directories and systemd services being deleted
permanently.
