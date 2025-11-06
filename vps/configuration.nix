# /Documents/nix-config/vps/configuration.nix

{ config, pkgs, inputs, ... }:

{
  imports = [
    (inputs.nixpkgs + "/nixos/modules/profiles/minimal.nix")
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  networking.hostName = "nixOS-25_05-4GB-nbg1-1";
  time.timeZone = "Europe/Paris";

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  # Open SSH port in the firewall
  networking.firewall.allowedTCPPorts = [
    22
  ];

  # Define root
  users.users.root = {
    initialPassword = "root";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2uzDX8j0gCkpfmB+G9HU3PEEOGp02Nfh4FcIlQ+EWb alois.vincent@imt-atlantique.net"
    ];
  };

  system.stateVersion = "25.05";
}
