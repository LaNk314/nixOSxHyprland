# Roadmapa: od gołego Hyprlanda do pełnego środowiska

Lista „na wyrost” funkcji, które w pełnym DE (GNOME, KDE) działają od razu, a pod Hyprlandem trzeba je złożyć samemu. Niepotrzebne pozycje wytnij.

Legenda: ✅ jest · 🔶 częściowo · ⬜ brak · 💻 ma sens dopiero na laptopie
Kolumna **NixOS** podaje moduł, jeśli istnieje. Bez modułu wystarczy pakiet w `environment.systemPackages`.

## 1. Podstawy sesji

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| ✅ | Ekran logowania | greetd + tuigreet | `services.greetd` | alternatywy graficzne: regreet, SDDM |
| ⬜ | Polkit agent (okienka z hasłem dla aplikacji GUI) | hyprpolkitagent | `security.polkit.enable` + pakiet | bez niego np. montowanie w nautilusie albo nm-connection-editor nie zapyta o hasło |
| ⬜ | Keyring (hasła Wi-Fi, przeglądarki, git) | gnome-keyring | `services.gnome.gnome-keyring.enable`, `security.pam.services.greetd.enableGnomeKeyring` | odblokowanie przy logowaniu |
| ✅ | Portale XDG (udostępnianie ekranu, okna wyboru plików) | xdg-desktop-portal-hyprland + -gtk | ustawia `programs.hyprland` | sprawdzić okno wyboru plików (portal gtk) |
| ✅ | Blokada ekranu | hyprlock | `programs.hyprlock.enable` | SUPER+L; moduł dodaje PAM |
| 🔶 | Bezczynność: wygaszanie, blokada, uśpienie | hypridle | pakiet + autostart (`services.hypridle` wymaga `graphical-session.target`) | blokada po 5 min; DPMS i suspend 💻 zakomentowane |
| ⬜ | Menu zasilania (wyloguj / restart / wyłącz) | wlogout, skrypt w fuzzel | pakiet | dziś jest tylko SUPER+M (exit) |
| ⬜ | Automatyczny start aplikacji XDG (`~/.config/autostart`) | — | `hl.exec_cmd` w `hyprland.start` | Hyprland nie obsługuje tego sam |

## 2. Wygląd i spójność

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| 🔶 | Pasek | waybar | pakiet / `programs.waybar.enable` | brak modułów: sieć, bluetooth, bateria 💻, tray, język klawiatury |
| ✅ | Tapeta | swaybg | | alternatywy: hyprpaper, swww (animacje) |
| ⬜ | Motyw GTK (jasny/ciemny) | adw-gtk3, catppuccin-gtk | pakiet + `gsettings`/dconf albo Home Manager | dziś aplikacje GTK mogą wyglądać „surowo” |
| ⬜ | Motyw Qt zgodny z GTK | qt6ct, kvantum | `qt.enable`, `qt.platformTheme`, `qt.style` | |
| ⬜ | Ikony | papirus-icon-theme | pakiet | |
| ⬜ | Kursor (motyw + rozmiar, także w XWayland) | bibata-cursors, hyprcursor | `XCURSOR_THEME/SIZE`, `HYPRCURSOR_*` | |
| 🔶 | Fonty i emoji | noto, noto-emoji, nerd-fonts | `fonts.packages`, `fonts.fontconfig.defaultFonts` | brak emoji i domyślnych krojów |
| ⬜ | Jednolity motyw kolorów dla wszystkiego | stylix, catppuccin/nix | flake | wygodne, ale wymaga flakes / Home Managera |
| ⬜ | Animacje, zaokrąglenia, blur, gapy | — | `hyprland.lua` | dopracowanie wyglądu |
| ⬜ | Skalowanie HiDPI 💻 | — | `hl.monitor({ scale = … })` | na laptopie np. 1.25 / 1.5 |

## 3. Okna, workspace'y, skróty

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| 🔶 | Launcher aplikacji | fuzzel | | SUPER+R jest zepsute (2026-11-25-02) |
| ⬜ | Przełącznik okien (Alt+Tab) | wbudowane dispatchery, hyprswitch | | |
| ⬜ | Reguły okien (float dla dialogów, pavucontrol, PiP) | — | `hyprland.lua` | |
| ⬜ | Scratchpad (podręczny terminal) | special workspace | | SUPER+S już jest w domyślnym configu |
| ⬜ | Ściągawka skrótów | skrypt + fuzzel | | przydaje się na początku |
| ⬜ | Gesty touchpada (przełączanie workspace'ów) 💻 | wbudowane `gestures` | `hyprland.lua` | |
| ⬜ | Podział configu na pliki | `require("binds")` itp. | | czytelność `hyprland.lua` |

## 4. Wejście: klawiatura, mysz, język

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| ⬜ | Układ PL (polskie znaki przez AltGr) | `kb_layout = "pl"` | `hyprland.lua` (input) + `console.keyMap` | dziś jest `us` bez wariantu |
| ⬜ | Przełączanie układów i wskaźnik w pasku | — | waybar `hyprland/language` | jeśli potrzeba więcej niż jednego układu |
| ⬜ | Touchpad: tap-to-click, natural scroll 💻 | — | `hyprland.lua` input.touchpad | |
| ⬜ | Metody wprowadzania (CJK, emoji picker) | fcitx5, `bemoji` | `i18n.inputMethod` | raczej na wyrost |

## 5. Schowek, zrzuty, nagrywanie

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| ✅ | Schowek Wayland | wl-clipboard | | |
| ⬜ | Historia schowka | cliphist + fuzzel | pakiet | np. SUPER+V (dziś float toggle) |
| 🔶 | Zrzuty ekranu | grim + slurp | | brak zapisu do pliku i adnotacji (swappy, satty) |
| ⬜ | Nagrywanie ekranu | wf-recorder, gpu-screen-recorder | pakiet / `programs.gpu-screen-recorder` | |
| ⬜ | Udostępnianie ekranu (Meet, Teams, Discord) | portal hyprland + pipewire | | do przetestowania w przeglądarce |
| ⬜ | Color picker | hyprpicker | pakiet | |
| ⬜ | Schowek host↔VM | spice-vdagent | `services.spice-vdagentd` | tylko VM, 2026-11-25-03 |

## 6. Powiadomienia i OSD

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| ✅ | Demon powiadomień | mako | | alternatywa z centrum powiadomień: swaync |
| ⬜ | Historia powiadomień / tryb „nie przeszkadzać” | `makoctl`, swaync | | |
| ⬜ | OSD głośności i jasności (wskaźnik na ekranie) | swayosd, avizo | pakiet (sprawdzić, czy jest moduł) | dziś skróty działają „po cichu” |

## 7. Dźwięk i multimedia

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| ✅ | Serwer dźwięku | pipewire + pulse | `services.pipewire` | |
| ⬜ | Mikser GUI | pavucontrol, pwvucontrol | pakiet | |
| ⬜ | Sterowanie odtwarzaczem (klawisze mediów) | playerctl | pakiet | skróty już są w configu, brak programu |
| ⬜ | Bluetooth audio 💻 | — | `hardware.bluetooth.enable`, `services.blueman.enable` | |
| ⬜ | Odtwarzacz wideo / audio | mpv, celluloid | pakiet | |
| ⬜ | Przeglądarka obrazów | imv, loupe | pakiet | |
| ⬜ | Przeglądarka PDF | zathura, papers | pakiet | |

## 8. Sieć i łączność

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| 🔶 | Zarządzanie siecią | NetworkManager | `networking.networkmanager` | jest, ale tylko z CLI (`nmtui`) |
| ⬜ | Applet sieci w trayu | nm-applet | `programs.nm-applet.enable` | wymaga traya w waybarze |
| ⬜ | Wi-Fi 💻 | NetworkManager | | firmware: `hardware.enableRedistributableFirmware` |
| ⬜ | VPN (WireGuard, OpenVPN, firmowy) | NM pluginy, wireguard-tools | `networking.wireguard` / NM plugins | |
| ⬜ | Bluetooth GUI 💻 | blueman, overskride | `services.blueman.enable` | |
| ⬜ | Firewall: świadome reguły | — | `networking.firewall` | domyślnie włączony, otwarte tylko 22 |
| ⬜ | Wykrywanie w sieci (mDNS, drukarki) | avahi | `services.avahi` | |

## 9. Pliki i nośniki

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| 🔶 | Menedżer plików | nautilus, yazi | | brak gvfs (2026-11-25-02) |
| ⬜ | Kosz, MTP (telefon), sieć (smb/sftp) | gvfs | `services.gvfs.enable` | |
| ⬜ | Automontowanie pendrive'ów | udiskie | `services.udisks2.enable` + udiskie w autostarcie | |
| ⬜ | Miniatury | tumbler / ffmpegthumbnailer | `services.tumbler.enable` | |
| ⬜ | Archiwa | file-roller, unzip, p7zip | pakiet | |
| ⬜ | Domyślne aplikacje (`xdg-open`) | — | `xdg.mime.defaultApplications` | który program otwiera PDF / obraz / link |
| ⬜ | Katalogi użytkownika (Pobrane, Dokumenty) | xdg-user-dirs | pakiet / Home Manager | |

## 10. Zasilanie i sprzęt 💻

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| ⬜ | Profile zasilania | power-profiles-daemon albo tlp | `services.power-profiles-daemon` / `services.tlp` | nie oba naraz |
| ⬜ | Bateria w pasku, ostrzeżenie o niskim stanie | waybar `battery`, upower | `services.upower.enable` | |
| ⬜ | Jasność ekranu | brightnessctl | pakiet + grupa `video` | skróty już są w configu |
| ⬜ | Zamknięcie klapy → uśpienie | logind | `services.logind.lidSwitch` | |
| ⬜ | Hibernacja | swap ≥ RAM | `boot.resumeDevice` | decyzja przy partycjonowaniu |
| ⬜ | Monitor zewnętrzny / dock, profile ekranów | kanshi, nwg-displays | `hl.monitor` / pakiet | |
| ⬜ | Sterowniki GPU (Intel/AMD/NVIDIA) | — | `hardware.graphics`, `hardware.nvidia` | NVIDIA + Hyprland wymaga dodatkowej pracy |
| ⬜ | Aktualizacje firmware | fwupd | `services.fwupd.enable` | |
| ⬜ | Odcisk palca | fprintd | `services.fprintd.enable` | jeśli laptop ma czytnik |
| ⬜ | Night light | hyprsunset, gammastep | pakiet | |

## 11. Drukowanie i skanowanie

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| ⬜ | Drukarki | CUPS | `services.printing.enable` (+ avahi) | |
| ⬜ | Skaner | sane, simple-scan | `hardware.sane.enable` | |

## 12. Aplikacje codzienne

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| ⬜ | Przeglądarka | firefox, chromium | `programs.firefox.enable` | |
| ⬜ | Edytor tekstu GUI / IDE | vscodium, gnome-text-editor | pakiet | |
| ✅ | Terminal | kitty | | brak własnego configu |
| ⬜ | Kalkulator, monitor systemu | qalculate, btop, mission-center | pakiet | |
| ⬜ | Komunikatory / poczta | thunderbird, signal-desktop… | pakiet | lista z Debiana (2026-11-25-04) |
| ⬜ | Menedżer haseł | keepassxc, bitwarden | pakiet | |
| ⬜ | Flatpak (aplikacje spoza nixpkgs) | — | `services.flatpak.enable` | opcjonalne |

## 13. Bezpieczeństwo, backup, utrzymanie

| | Funkcja | Popularne wybory | NixOS | Uwagi |
|---|---|---|---|---|
| ⬜ | Szyfrowanie dysku 💻 | LUKS | instalator / `boot.initrd.luks` | decyzja przed instalacją |
| ✅ | SSH tylko po kluczu | — | `services.openssh` | |
| ⬜ | Agent SSH / GPG | gnome-keyring / gpg-agent | `programs.gnupg.agent` | |
| ⬜ | Backup danych | restic, borg, pika-backup | `services.restic.backups` | |
| ⬜ | Snapshoty systemu plików | btrfs + snapper | `services.snapper` | wymaga btrfs |
| ⬜ | Automatyczne czyszczenie starych generacji | nix gc | `nix.gc.automatic`, `boot.loader.systemd-boot.configurationLimit` | inaczej `/boot` się zapełni |
| ⬜ | Optymalizacja store | — | `nix.settings.auto-optimise-store` | |
| ⬜ | Automatyczne aktualizacje | — | `system.autoUpgrade` | albo świadomie ręcznie |
| ⬜ | Diff zmian przed rebuildem | nvd, nix-output-monitor, nh | pakiet | wygodniejszy `nixos-rebuild` |

## 14. Organizacja konfiguracji (NixOS)

| | Funkcja | Popularne wybory | Uwagi |
|---|---|---|---|
| ⬜ | Config w repo jako źródło prawdy (zamiast kopii z VM) | symlink `/etc/nixos` → repo albo `nixos-rebuild --flake` | dziś repo trzyma tylko kopie |
| ⬜ | Flakes (przypięte wersje, powtarzalność) | `nix.settings.experimental-features` | |
| ⬜ | Home Manager (dotfiles deklaratywnie) | moduł NixOS | hyprland.lua, waybar, kitty generowane z Nixa |
| ⬜ | Podział na moduły | `imports = [ ./desktop.nix ./laptop.nix … ]` | wspólna baza VM + laptop |
| ⬜ | Dwa hosty w jednym repo (VM, laptop) | flake `nixosConfigurations.<host>` | VM zostaje jako środowisko testowe |

## Proponowana kolejność

1. **Porządki:** 2026-11-25-02 (SUPER+R, gvfs, playerctl, brightnessctl).
2. **Codzienna używalność:** układ PL, polkit, keyring, blokada + hypridle, menu zasilania, pavucontrol, historia schowka, OSD.
3. **Wygląd:** motyw GTK/Qt, ikony, kursor, fonty i emoji, rozbudowa waybara (tray, sieć).
4. **Organizacja:** repo jako źródło prawdy, potem flakes, Home Manager i moduły.
5. **Laptop 💻:** zasilanie, Wi-Fi, BT, touchpad, HiDPI, LUKS, backup (2026-11-25-04).
