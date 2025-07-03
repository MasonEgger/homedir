# homedir

When I am setting up a shell account on a new machine, I check this homedir repository out into my new home directory and set it up like this 

```bash
$ cd
$ git co https://github.com/brandon-rhodes/homedir.git
$ mv homedir/.[Xa-z]* homedir/* .
$ rmdir homedir
```

## Claude.md

Claude.md crafted by myself, and shamelessly taken from [harperreed](https://github.com/harperreed/dotfiles/tree/master/.claude)