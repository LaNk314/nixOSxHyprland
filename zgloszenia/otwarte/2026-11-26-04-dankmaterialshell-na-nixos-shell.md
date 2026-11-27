---
id: 2026-11-26-04
tytul: Gotowy shell DankMaterialShell na VM nixos-shell (gałąź shell)
status: w-toku
typ: zmiana
priorytet: sredni
otwarte: 2026-11-26
zamkniete:
przyczyna:
powiazane: [2026-11-26-03]
---

## Opis

Na VM `nixos-shell` (klonie zamrożonej `nixos`, zob. 2026-11-26-03) zainstalować DankMaterialShell (DMS). Cel: zobaczyć Hyprlanda z kompletnym shellem (pasek, launcher, powiadomienia, panel ustawień) i ocenić, czy to dobra baza zamiast ręcznego składania komponentów.

Repo: cała praca na gałęzi **`shell`**. Tam trafiają kopie configu z `nixos-shell` (`nixos/`, `dotfiles/`) i to zgłoszenie. `main` dalej opisuje zamrożoną VM `nixos`.

## Diagnoza

Stan nixpkgs przypiętego w `flake.lock` VM (26.05, rev 0dc498b), sprawdzony 2026-11-26 przez `nix eval`:

- Pakiet `dms-shell` ma wersję **1.4.6**.
- Moduł NixOS nazywa się **`programs.dms-shell`**, nie `programs.dank-material-shell` jak w dokumentacji dla flake'a upstream (`nixos/modules/programs/wayland/dms-shell.nix`). Opcje:
  - `enable`, `package`
  - `systemd.enable` (domyślnie `true`): usługa użytkownika `dms` startuje z `systemd.target`, domyślnie `graphical-session.target`; dalej `systemd.restartIfChanged`
  - `enableSystemMonitoring` (dgop), `enableVPN`, `enableDynamicTheming` (matugen), `enableAudioWavelength` (cava), `enableCalendarEvents`, `enableClipboardPaste`; wszystkie domyślnie `true`
  - `quickshell.package`, `plugins`
  - Moduł włącza też domyślnie `power-profiles-daemon`, `accounts-daemon`, `hardware.i2c`.
- W tym samym nixpkgs jest `services.displayManager.dms-greeter`, czyli greeter DMS jako możliwa alternatywa dla ReGreet.
- Dokumentacja DMS przeniosła się z danklinux.com na duxlabs.dev (2.0 = „Dux Shell”). Strony renderuje JavaScript, więc nie dało się ich odczytać narzędziami.

Ryzyka do sprawdzenia:
- Generowanie configu Hyprlanda w Lua weszło w DMS **1.5**, a nixpkgs ma 1.4.6. Społeczność zgłaszała, że przy Hyprlandzie w Lua nie działał przełącznik obszarów roboczych (poprawka w nowszych wersjach). Jeśli to wyjdzie, w grę wchodzi nowsza wersja z flake'a upstream.
- `graphical-session.target`: w obecnej konfiguracji hypridle startuje z autostartu Hyprlanda, a nie z systemd. Trzeba sprawdzić, czy sesja Hyprlanda spod greetd w ogóle aktywuje ten target. Jeśli nie, zostaje `systemd.enable = false` i start przez `hl.on("hyprland.start", …)` w `hyprland.lua`.
- Konflikty z obecnymi komponentami: waybar, mako (powiadomienia), fuzzel, swaybg, hyprpolkitagent, wlogout. DMS ma własne odpowiedniki, więc nasze trzeba wyłączyć w autostarcie i `home.nix`.
- Kolory: DMS ma własny motyw i matugen. Na czas eksperymentu zasada „tylko Stylix” nie obejmuje shella.

### Przebieg

- 2026-11-26: Ustawiono `programs.dms-shell.enable = true` i przebudowano system. Usługa `dms` jest `inactive (dead)`, bo plik unit ma `Requisite=graphical-session.target`, a w sesji spod greetd ten target jest nieaktywny. Usługa ma też `Type=dbus` z `BusName=org.freedesktop.Notifications`, więc DMS zastępuje mako.
- 2026-11-26: Ustawiono `programs.dms-shell.systemd.enable = false`. W `hyprland.lua` autostart `dms run` zastąpił waybar, mako i swaybg; hypridle i hyprpolkitagent zostały. DMS działa (quickshell 0.3.0).
- 2026-11-27: Pierwsze wrażenia użytkownika: DMS nie obsługuje ekranu logowania, ekranu pod SUPER+M ani wyglądu kafelkowania. Wyjaśnienie:
  - DMS to warstwa widżetów (layer-shell) nad kompozytorem. Ramki, odstępy, zaokrąglenia i animacje okien ustawia Hyprland w `hyprland.lua`.
  - Ekran logowania działa przed sesją użytkownika, więc potrzebny jest osobny greeter: `services.displayManager.dms-greeter` jest w nixpkgs.
  - SUPER+M i SUPER+R nadal wywołują wlogout i fuzzel. DMS ma odpowiedniki dostępne przez IPC.
- 2026-11-27: Cele IPC (`dms ipc <cel> <funkcja>`) w 1.4.6: `spotlight`, `launcher`, `powermenu`, `lock`, `notifications`, `control-center`, `settings`, `clipboard`, `hypr` (toggleOverview, toggleBinds), `wallpaper`, `night`, `processlist`, `audio`, `brightness`, `mpris`, `keybinds` i inne.
- 2026-11-27: Blokada: SUPER+L wywołuje `dms ipc lock lock`, hypridle usunięty z autostartu. DMS ma `loginctlLockIntegration: true`, więc wcześniej `loginctl lock-session` uruchamiał dwie blokady naraz. Blokada po bezczynności w DMS (`acLockTimeout`, `lockBeforeSuspend`) nie zapisała się, trzeba ją ustawić ponownie.
- 2026-11-27: ReGreet zastąpiony przez `services.displayManager.dms-greeter` (`compositor.name = "hyprland"`, `configHome = "/home/lank"`). Działa, a keyring nadal odblokowuje się przez PAM `greetd` („gnome-keyring-daemon started properly and unlocked keyring”). Problemy:
  - Kursor w greeterze jest domyślny. Greeter działa jako użytkownik systemowy `dms-greeter`, a motyw kursora ze Stylixa jest tylko w profilu Home Managera użytkownika `lank`: `/run/current-system/sw/share/icons` zawiera wyłącznie `hicolor` i `locolor`.
  - Po zalogowaniu na chwilę widać tty, a potem domyślną tapetę Hyprlanda, zanim DMS narysuje swoją. Tty pojawia się, bo Hyprland greetera kończy pracę przed startem sesji (cecha greetd). Tapeta to `force_default_wallpaper = -1` i `disable_hyprland_logo = false` w `hyprland.lua`.
  - Skrypt `dms-greeter` (1.4.6) generuje config Hyprlanda w **hyprlang**. Jeśli `customConfig` jest ustawione, dopisuje do niego tylko `exec-once`. Domyślnych `env = DMS_RUN_GREETER,1` i `misc { disable_hyprland_logo }` trzeba wtedy dodać samemu.

## Przyczyna źródłowa

Nie dotyczy (zmiana).

## Rozwiązanie

- [ ] Odświeżyć w gałęzi `shell` kopię configu z `nixos-shell` (punkt wyjścia)
- [ ] `programs.dms-shell.enable = true;` w `configuration.nix`, przebudowa `--flake /etc/nixos#nixos`
- [x] Start DMS: `systemd.enable = false`, autostart `dms run` w `hyprland.lua`
- [x] Wyłączyć waybar, mako i swaybg
- [ ] Skróty DMS: launcher, menu zasilania, blokada, powiadomienia, ustawienia, schowek, overview
- [x] Blokada: DMS (`dms ipc lock lock`), hypridle usunięty z autostartu
- [ ] Blokada po bezczynności i przed uśpieniem w ustawieniach DMS
- [ ] Wygląd okien w Hyprlandzie (ramki, zaokrąglenia, animacje) dopasowany do DMS
- [x] dms-greeter zamiast ReGreet
- [ ] Kursor ze Stylixa w greeterze (`compositor.customConfig`)
- [ ] Bez domyślnej tapety Hyprlanda przy starcie sesji (`misc` w `hyprland.lua`)
- [ ] Przetestować obszary robocze, powiadomienia, panel ustawień, blokadę ekranu
- [ ] Ocena i decyzja: zostajemy przy DMS (scalenie do `main`), inny shell albo powrót do ręcznej konfiguracji

## Wnioski
