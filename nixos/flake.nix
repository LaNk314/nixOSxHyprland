{
  description = "NixOS + Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";   # HM używa tego samego nixpkgs, bez drugiej kopii
    };
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, stylix, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        ./stylix.nix
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;       # pakiety i allowUnfree z systemu
          home-manager.useUserPackages = true;     # pakiety HM w profilu użytkownika
          home-manager.backupFileExtension = "hm-backup";  # istniejący plik zostanie przemianowany, a nie zablokuje aktywacji
          home-manager.users.lank = import ./home.nix;
        }
      ];
    };
  };
}
