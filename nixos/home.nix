{ config, lib, pkgs,  ... }:
let
  # Paleta ze stylix.nix (Everforest); wartości hex bez '#', np. c.base0D = "7fbbb3"
  c = config.lib.stylix.colors;
  names = [ "base00" "base01" "base02" "base03" "base04" "base05" "base06" "base07"
            "base08" "base09" "base0A" "base0B" "base0C" "base0D" "base0E" "base0F" ];
  # dla każdej z 16 nazw jedna linia w formacie podanym przez f
  each = f: lib.concatMapStrings (n: f n c.${n} + "\n") names;
in
{
  home.stateVersion = "26.05";   # jak system.stateVersion: ustaw raz, nie zmieniaj przy aktualizacjach

  # Pliki generowane z palety (tylko do odczytu). Twoje configi je dołączają.
  xdg.configFile = {
    "hypr/colors.lua".text = ''
      -- generowane przez Home Manager z palety Stylix; zmiany w /etc/nixos/home.nix
      return {
      ${each (n: v: "  ${n} = \"${v}\",")}}
    '';
    "hypr/colors.conf".text = each (n: v: "\$${n} = rgb(${v})");          # hyprlock (hyprlang)
    "waybar/colors.css".text = each (n: v: "@define-color ${n} #${v};");  # waybar (GTK CSS)
    "wlogout/colors.css".text = each (n: v: "@define-color ${n} #${v};");
    "wlogout/icons".source = "${pkgs.wlogout}/share/wlogout/icons";   # stała ścieżka do ikon z pakietu
    "kitty/colors.conf".text = with c.withHashtag; ''
      background ${base00}
      foreground ${base05}
      selection_background ${base02}
      selection_foreground ${base05}
      cursor ${base05}
      cursor_text_color ${base00}
      url_color ${base0D}
      active_tab_background ${base02}
      active_tab_foreground ${base05}
      inactive_tab_background ${base01}
      inactive_tab_foreground ${base04}
      color0 ${base00}
      color1 ${base08}
      color2 ${base0B}
      color3 ${base0A}
      color4 ${base0D}
      color5 ${base0E}
      color6 ${base0C}
      color7 ${base05}
      color8 ${base03}
      color9 ${base08}
      color10 ${base0B}
      color11 ${base0A}
      color12 ${base0D}
      color13 ${base0E}
      color14 ${base0C}
      color15 ${base07}
    '';
  };

  # mako i fuzzel nie mają własnych configów, więc w całości konfiguruje je Stylix
  services.mako.enable = true;
  programs.fuzzel.enable = true;
}
