---
id: 2026-11-26-02
tytul: Graficzny ekran logowania (ReGreet) i ekran startu (Plymouth)
status: nowe
typ: zmiana
priorytet: niski
otwarte: 2026-11-26
zamkniete:
przyczyna:
powiazane: [2026-11-25-04]
---

## Opis

Ekran logowania po starcie wygląda jak BIOS, bo tuigreet jest tekstowym greeterem na konsoli TTY. Wygląda to gorzej niż blokada ekranu (hyprlock). Do tego przed logowaniem przewijają się komunikaty systemd.

Cel:
- graficzny greeter w palecie Stylixa,
- graficzny ekran startu zamiast komunikatów rozruchu.

## Przebieg

- 2026-11-26: Rozważono trzy opcje:
  - ReGreet (graficzny greeter GTK dla greetd w kompozytorze `cage`),
  - autologin + hyprlock od startu,
  - SDDM.

  Wybrano **ReGreet**. greetd zostaje, a Stylix ma target `regreet`. Autologin odrzucono, mimo że laptop będzie miał LUKS: ReGreet wystarcza i nie omija hasła użytkownika.
- Dodatkowo **Plymouth** (graficzny ekran startu). Stylix ma target `plymouth`.
- Stan VM: sesje Wayland pochodzą z `programs.hyprland` (`hyprland.desktop` → `start-hyprland`, `hyprland-uwsm.desktop`). ReGreet pokaże obie, a domyślna ma być „Hyprland”.
- Przy okazji: `~/tapeta.jpg` nie istnieje w VM, więc swaybg z autostartu nic nie wyświetla. Stylix nie ma ustawionego `image`, więc ReGreet dostanie tło jednolite z palety.
- 2026-11-26, po pierwszym wdrożeniu: ReGreet i Plymouth działają (plymouthd startuje i kończy się w journalu), ale pojawiły się dwa problemy:
  1. **Po zalogowaniu wyświetla się TTY (bash) zamiast Hyprlanda.** Log `/var/log/regreet/log` pokazuje `sess_id: None` i komunikat `No entry found; using default login shell of user: lank` (polecenie `["/run/current-system/sw/bin/bash"]`). Przy pierwszym starcie ReGreet nie ma `/var/lib/regreet/state.toml`, więc nie wybiera żadnej sesji. Bez wybrania sesji z listy uruchamia powłokę użytkownika.
  2. **Kursor jest odwrócony do góry nogami w ReGreet.** `cage` (wlroots) używa sprzętowego kursora na virtio-gpu z virgl. Hipoteza: znany problem z płaszczyzną kursora w wirtualnym GPU. Obejście: `WLR_NO_HARDWARE_CURSORS=1`. Hyprland (aquamarine, nie wlroots) nie ma tego problemu.

## Przyczyna źródłowa

tuigreet to greeter tekstowy (TUI), który działa na TTY. Konsola tekstowa nie da wyglądu porównywalnego z hyprlockiem.

## Rozwiązanie

Zmiany w `/etc/nixos/configuration.nix` w VM wykonuje użytkownik:

- [ ] Usunąć blok `settings.default_session` (tuigreet) z `services.greetd`. Jeśli go zostawić, wystąpi konflikt z `programs.regreet`, który sam ustawia polecenie greetd (`cage … regreet`).
- [ ] Dodać `programs.regreet.enable = true;`. Kolory, font i kursor ustawi target Stylixa.
- [ ] Dodać Plymouth i cichy rozruch: `boot.plymouth.enable = true;`, `boot.consoleLogLevel = 3;`, `boot.initrd.verbose = false;`, `boot.kernelParams = [ "quiet" "splash" "udev.log_level=3" "systemd.show_status=auto" ];`
- [ ] `nixos-rebuild switch --flake /etc/nixos#nixos`, potem reboot i sprawdzenie
- [ ] Jeśli splash nie pojawia się w VM: `boot.initrd.kernelModules = [ "virtio_gpu" ];` (wczesny KMS)
- [ ] Odświeżyć kopię w repo, zaktualizować README (Logowanie, Komponenty, Troubleshooting)

Na laptopie z LUKS: `boot.initrd.systemd.enable = true;`. Wtedy Plymouth pokaże graficzne pole na hasło do dysku (do zgłoszenia 2026-11-25-04).

Wycofanie: wybrać poprzednią generację w menu systemd-boot albo przełączyć się na TTY2 (Ctrl+Alt+F2).

## Wnioski
