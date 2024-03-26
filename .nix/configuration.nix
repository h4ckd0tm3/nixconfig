{ config, pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;
}