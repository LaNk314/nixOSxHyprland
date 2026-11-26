{ pkgs, ... }:
{
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";

    fonts = {
      monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };
      sansSerif = { package = pkgs.noto-fonts;              name = "Noto Sans"; };
      serif     = { package = pkgs.noto-fonts;              name = "Noto Serif"; };
      emoji     = { package = pkgs.noto-fonts-color-emoji;  name = "Noto Color Emoji"; };
    };

    cursor = { package = pkgs.bibata-cursors; name = "Bibata-Modern-Classic"; size = 24; };
  };

  # target GTK w Home Managerze zapisuje ustawienia przez dconf
  programs.dconf.enable = true;
}
