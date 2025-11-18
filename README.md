# Instructions

Install nix from https://nixos.org/download/

Install home manager from https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone

Create an `options.nix` to define the custom variables like:
```nix
let
  username         = "me";
  userHome         = "/home/${username}";
  gitName          = "John Doe";
  gitEmail         = "john.doe@example.org";
  gitDefaultBranch = "main";
  githubUser       = "jdoe";

in {
  username         = username;
  userHome         = userHome;
  gitName          = gitName;
  gitEmail         = gitEmail;
  gitDefaultBranch = gitDefaultBranch;
  githubUser       = githubUser;
}
```

create a symlink to the folder like:

```
$ ln -s home-laptop $HOME/.config/home-manager
```