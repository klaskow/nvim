# Neovim

## Requirements

- [ripgrep](https://github.com/BurntSushi/ripgrep)

## Measure with `profile`

```vim
:profile start profile.log
:profile func *
:profile file *
" <slow actions>
:profile stop
:noautocmd qall
```
