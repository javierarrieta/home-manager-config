# Modular Home Manager Configuration

This is a modular configuration structure for Home Manager that allows you to use different parts of the configuration across different computers.

## Directory Structure

```
.
├── flake.nix                 # Main flake configuration
├── modules/
│   └── base.nix              # Base configuration shared across all hosts
├── hosts/
│   ├── oracle/
│   │   ├── home.nix          # oracle-specific configuration
│   │   �n── options.nix       # oracle-specific options
│   └── macbookair/
│       ├── home.nix          # macbookair-specific configuration
│       └── options.nix       # macbookair-specific options
```

## Usage

To use this configuration on a specific host:

1. **For oracle**:
   ```bash
   home-manager switch --flake .#oracle
   ```

2. **For macbookair**:
   ```bash
   home-manager switch --flake .#macbookair
   ```

## Adding New Hosts

1. Create a new directory under `hosts/` with your host name
2. Create `home.nix` and `options.nix` files in that directory
3. Add the new host configuration to `flake.nix`
4. Run `home-manager switch --flake .#<hostname>`

## Adding New Modules

1. Create a new `.nix` file in the `modules/` directory
2. Import it in your host configuration using the `imports` option
3. Add specific settings or packages to the module

This structure allows you to maintain a consistent configuration across different machines while customizing for specific needs.