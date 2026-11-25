---
id: 2026-11-25-01
tytul: Instalacja bazowa VM NixOS + Hyprland i dostęp SSH
status: zamkniete
typ: zmiana
priorytet: sredni
otwarte: 2026-11-25
zamkniete: 2026-11-25
przyczyna: Potrzebne środowisko testowe NixOS + Hyprland przed migracją laptopa z Debiana.
powiazane: [2026-11-25-02, 2026-11-25-03, 2026-11-25-04]
---

## Opis

Instalacja NixOS w VM (KVM) bez DE, potem Hyprland i podstawowe narzędzia. Użytkownik pierwszy raz pracuje z Nixem.

## Przebieg

1. Instalacja NixOS 26.05 (systemd-boot, NetworkManager, użytkownik `lank`).
2. **vim:** dopisany do `environment.systemPackages` i ustawiony `programs.vim.defaultEditor = true`. `nixos-rebuild` zgłosił asercję: `defaultEditor` wymaga `programs.vim.enable = true`. Poprawka: `programs.vim = { enable = true; defaultEditor = true; };`.
3. **`.vimrc`:** po podlinkowaniu `~/.vimrc` do `/root/.vimrc` polecenie `sudo vim` przestało kolorować składnię. Przyczyna: gdy istnieje vimrc, vim pomija `defaults.vim` (który włącza `syntax on`). Do `.vimrc` dopisano `syntax on` i `filetype plugin indent on`. Zalecane jest `sudoedit` zamiast symlinku do roota.
4. **Hyprland:** `programs.hyprland.enable`, `xwayland.enable`, `hardware.graphics.enable`, `NIXOS_OZONE_WL=1`. Hyprland 0.55.4 wygenerował config w **Lua** (`hyprland.lua`), nie `hyprland.conf`.
5. **Rozdzielczość:** domyślnie ok. 800x600 (`mode = "preferred"`). Poprawka w bloku `hl.monitor`: `mode = "1920x1080@60"`, `scale = 1`.
6. **Środowisko:** waybar, fuzzel, mako, libnotify, swaybg, grim, slurp, wl-clipboard, yazi, nautilus, fonty noto i nerd-fonts.jetbrains-mono, pipewire. Autostart przez `hl.on("hyprland.start", …)`. Skróty: SUPER+D (fuzzel), Print/SHIFT+Print (zrzut do schowka), SUPER+E (nautilus). Waybar z własnym `config.jsonc` i `style.css` (paleta Catppuccin Mocha).
7. **Start przy boocie:** `services.greetd` z `tuigreet --cmd start-hyprland`.
8. **SSH:** `services.openssh` z `PermitRootLogin = "no"` i `PasswordAuthentication = false`, logowanie kluczem ed25519, alias `ssh nixos` na hoście. Odczyt z hosta potwierdzony 2026-11-25: `nixos-version` 26.05.15079, sshd i greetd aktywne.
9. Założono repo projektu i skopiowano configi do `nixos/` i `dotfiles/`.

## Rozwiązanie

- [x] NixOS + Hyprland działa w VM i startuje przez greetd
- [x] SSH po kluczu
- [x] Configi w repo

## Wnioski

- Na NixOS najpierw sprawdzaj, czy istnieje moduł (`programs.X`, `services.X`). Sam pakiet w `systemPackages` nie zawsze wystarcza.
- Porady o Hyprlandzie w internecie często dotyczą starej składni hyprlang. W wersji ≥0.55 config jest w Lua.
- Przepisywanie przez OCR wprowadzało błędy. Od teraz pliki przenosimy przez SSH i scp.
