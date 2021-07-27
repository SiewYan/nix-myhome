# Git settings

{ config, lib, pkgs, ... }:

{

  programs.git = {
    enable = true;
    userName = "SiewYan";
    userEmail = "siew.yan.hoh@cern.ch";
    aliases = {
      st = "status";
    };
  };
  
}
