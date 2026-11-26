---
id: 2026-11-26-01
tytul: Menu zasilania: wlogout pod SUPER+M i przycisk w waybarze
status: zamkniete
typ: zmiana
priorytet: sredni
otwarte: 2026-11-26
zamkniete: 2026-11-26
przyczyna: Domyślny config Hyprlanda nie ma menu zasilania, a SUPER+M od razu kończył sesję.
powiazane: [2026-11-25-04]
---

## Opis

Brak menu zasilania (roadmapa, sekcja 1). SUPER+M od razu kończy sesję (`hl.dsp.exit()`, bo `hyprshutdown` nie jest zainstalowany), bez pytania. Łatwo wylogować się przypadkiem.

Cel: graficzne menu z pozycjami: zablokuj, wyloguj, uruchom ponownie, wyłącz. Uśpienie dodamy dopiero na laptopie 💻. Menu otwiera SUPER+M albo przycisk ⏻ w waybarze.

## Diagnoza

- 2026-11-26: Rozważone opcje: skrypt `fuzzel --dmenu` albo **wlogout**. Wybrany wlogout (duże kafle z ikonami, obsługa myszą).
- 2026-11-26: Stan VM (odczyt): brak `wlogout` i `hyprshutdown`; sesja lokalna (`Type=wayland`, `Remote=no`), więc `systemctl reboot`/`poweroff` działa bez hasła (polkit/logind dla aktywnej sesji lokalnej). Font `JetBrainsMono Nerd Font` (waybar) ma znak ⏻.
- 2026-11-26: Paczka nixpkgs `wlogout` 1.2.2 ma domyślne `layout` i `style.css` w `$out/etc/wlogout`, z poprawionymi ścieżkami do ikon (`$out/share/wlogout/icons`). wlogout szuka każdego pliku osobno: najpierw `~/.config/wlogout/`, potem domyślnego. Wystarczy więc własny `layout`, a styl i ikony zostaną domyślne. Ikony przypisane są po `label` (`lock`, `logout`, `reboot`, `shutdown`, `suspend`, `hibernate`), więc tych nazw nie zmieniamy.

## Przyczyna źródłowa

Domyślny config Hyprlanda nie ma menu zasilania; SUPER+M to natychmiastowe wyjście.

## Rozwiązanie

- 2026-11-26: Wdrożone w VM według instrukcji poniżej, testy OK. Layout zapisany w skróconej formie (jeden obiekt na linię). Kopie w repo odświeżone.


Instrukcja do wykonania w VM:

1. `sudoedit /etc/nixos/configuration.nix` → w `environment.systemPackages` dopisz:
   ```nix
   wlogout    # menu zasilania (SUPER+M, przycisk w waybarze)
   ```
   potem `sudo nixos-rebuild switch`.

2. `~/.config/wlogout/layout` (format: kolejne obiekty JSON, bez tablicy i przecinków między nimi):
   ```json
   {
       "label" : "lock",
       "action" : "loginctl lock-session",
       "text" : "Zablokuj",
       "keybind" : "l"
   }
   {
       "label" : "logout",
       "action" : "hyprctl dispatch 'hl.dsp.exit()'",
       "text" : "Wyloguj",
       "keybind" : "e"
   }
   {
       "label" : "reboot",
       "action" : "systemctl reboot",
       "text" : "Uruchom ponownie",
       "keybind" : "r"
   }
   {
       "label" : "shutdown",
       "action" : "systemctl poweroff",
       "text" : "Wyłącz",
       "keybind" : "s"
   }
   ```
   Na laptopie 💻 dopisać `suspend` (`systemctl suspend`, klawisz `u`) i zmienić `-b 4` na `-b 5`.

3. `~/.config/hypr/hyprland.lua`: zamień linię SUPER+M na:
   ```lua
   hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pidof wlogout || wlogout -b 4"))   -- menu zasilania
   ```
   `-b 4` daje 4 przyciski w jednym rzędzie, a `pidof` zapobiega otwarciu drugiej kopii. Esc zamyka menu.

4. `~/.config/waybar/config.jsonc`:
   - `"modules-right": ["pulseaudio", "cpu", "memory", "clock", "custom/power"],`
   - nowy moduł:
     ```jsonc
     "custom/power": {
       "format": "⏻",
       "tooltip": false,
       "on-click": "pidof wlogout || wlogout -b 4"
     }
     ```
   `~/.config/waybar/style.css`: dodaj `#custom-power` do selektora `#pulseaudio, #cpu, #memory, #clock` i dopisz:
   ```css
   #custom-power { color: #f38ba8; }
   ```
   Waybar sam przeładuje styl (`reload_style_on_change`), ale zmiana `config.jsonc` wymaga restartu waybara: `pkill waybar; waybar & disown` albo ponownego zalogowania.

5. Test: SUPER+M i klik ⏻ → menu; Esc zamyka; „Zablokuj” → hyprlock; „Wyloguj” → tuigreet. Reboot i poweroff sprawdzić na końcu.

- [x] `wlogout` w `systemPackages` + rebuild
- [x] `~/.config/wlogout/layout`
- [x] SUPER+M → wlogout
- [x] przycisk ⏻ w waybarze
- [x] testy (blokada, wylogowanie, restart, wyłączenie)
- [x] odświeżyć kopie w repo (dopisać `.config/wlogout` do `tar` w README), README (Komponenty), roadmapa ✅

## Wnioski

- Własny `layout` wystarczy, bo wlogout szuka `layout` i `style.css` osobno i dla brakującego pliku bierze domyślny z pakietu (ścieżki do ikon są w nixpkgs poprawione).
- Na laptopie 💻 dodać `suspend` (i ewentualnie `hibernate` przy swapie ≥ RAM) oraz zmienić `-b 4` → `-b 5`.
