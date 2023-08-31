# simple-nvim-config
It doesn't need to be that complicated honestly.

## Extend configuration
Create a file:
- `lua/options.lua` or
- `lua/options/init.lua`

This will be automatically picked up after restarting nvim

## Add more plugins
Create any .lua file in `lua/plugins/` with the structue:
```lua
return {
    -- your plugins here
    { "someplugin" }, 
}

```

## Instalation
### Not Windows
- Fork this repo (optional)
- run `git clone <this repos url or the fork> ~/.config/nvim`
- run `nvim` and watch it set itself up
- profit

I tried to keep keymap settings colocated with where the plugin is being setup.
All plugins will either be found in `lua/plugins/<plugin name>.lua` or `lua/plugins/init.lua`

## Golang prerequisites
Install golangci on your local machine https://golangci-lint.run/usage/install

