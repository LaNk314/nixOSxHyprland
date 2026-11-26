---
id: 2026-11-26-04
tytul: Gotowy shell DankMaterialShell na VM nixos-shell (gałąź shell)
status: nowe
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

## Przyczyna źródłowa

Nie dotyczy (zmiana).

## Rozwiązanie

- [ ] Odświeżyć w gałęzi `shell` kopię configu z `nixos-shell` (punkt wyjścia)
- [ ] `programs.dms-shell.enable = true;` w `configuration.nix`, przebudowa `--flake /etc/nixos#nixos`
- [ ] Sprawdzić start DMS (`systemctl --user status dms`, `graphical-session.target`); w razie potrzeby autostart w `hyprland.lua`
- [ ] Wyłączyć zdublowane komponenty (waybar, mako, swaybg, …) i dodać skróty DMS (launcher, panel, blokada)
- [ ] Przetestować obszary robocze, powiadomienia, panel ustawień, blokadę ekranu
- [ ] Ocena i decyzja: zostajemy przy DMS (scalenie do `main`), inny shell albo powrót do ręcznej konfiguracji

## Wnioski
