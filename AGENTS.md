## Commands
- Format: `nixpkgs-fmt **/*.nix`
- Apply config: `home-manager switch --flake .#<hostname>` (oracle, macbookair)
- Enter dev shell: `nix develop`

## Code Style
- 2-space indentation for Nix files
- Module function args: `{ config, pkgs, unstablePkgs, pkgsUnfree, unstablePkgsUnfree, lib, userOptions, ... }`
- Use `let ... in ...` for local definitions
- Use `inherit (userOptions) attr1 attr2` for multi-attribute imports
- Host-specific files: `hosts/<hostname>/home.nix`, `hosts/<hostname>/userOptions.nix`
- Shared modules: `modules/*.nix`
- Pass data to modules via `_module.args.userOptions = userOptions`
- Imports: `imports = [ ../../modules/base.nix ]`
- No comments unless asked
