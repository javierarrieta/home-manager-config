# Instructions

Create an `options.nix` to define the custom variables like:
```nix
let
  username   = "me";
  userHome   = "/home/${username}";
  gitName    = "John Doe";
  gitEmail   = "john.doe@example.org";
  githubUser = "jdoe";
in {
  username   = username;
  userHome   = userHome;
  gitName    = gitName;
  gitEmail   = gitEmail;
  githubUser = githubUser;
}
```

create a symlink to the folder like:

```
$ ln -s home-laptop $HOME/.config/home-manager
```