{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixos-wsl, determinate, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
    inherit (import ./options.nix) username hostname flakeDir;
  in {
    nixosConfigurations = {
      "${hostname}" = nixpkgs.lib.nixosSystem {
        system = "${system}";
        modules = [
          determinate.nixosModules.default
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.11";

            # wsl specific settings
            wsl.enable = true;
            wsl.defaultUser = "${username}";
            wsl.useWindowsDriver = true;

            users = {
              users."${username}" = {
                shell = pkgs.zsh;
                ignoreShellProgramCheck = true;
              };
            };

            environment.systemPackages = with pkgs; [
              vim
              git
              btop
              lazygit
              nerd-fonts.noto
            ];

            fonts.packages = with pkgs; [
              nerd-fonts.noto
            ];

            environment.variables = {
              FLAKE = "${flakeDir}";
            };

            programs.nh.enable = true;

            nix = {
              settings = {
                auto-optimise-store = true;
                experimental-features = [ "nix-command" "flakes" ];
              };
            };
          }
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = {
              inherit username;
              inherit hostname;
              inherit inputs;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    };
  };
}
