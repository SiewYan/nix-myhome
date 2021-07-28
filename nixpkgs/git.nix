# Git settings

{ config, lib, pkgs, ... }:

let
  # extra config
  extraConfig = {
    core = {
      editor = "emacs";
      pager = "delta --dark";
      whitespace = "trailing-space,space-before-tab";
      };
      credential.helper = "store --file ~/.config/.my-credentials";
    };
in
{
  programs.git = {
    inherit extraConfig;
    enable = true;
    userName = "SiewYan";
    userEmail = "siew.yan.hoh@cern.ch";
    aliases = {
      st = "status";
    };
  };
}