---
id: 2026-11-26-03
tytul: Druga VM (nixos-shell) do testu gotowego shella, zamrożenie VM nixos
status: w-toku
typ: zmiana
priorytet: sredni
otwarte: 2026-11-26
zamkniete:
przyczyna:
powiazane: []
---

## Opis

Po dwóch dniach ręcznej konfiguracji środowisko wciąż nie nadaje się do codziennej pracy. Użytkownik do tej pory pracował w GNOME i chce zobaczyć pełne możliwości Hyprlanda na gotowym shellu. Eksperyment odbywa się na osobnej VM, a obecna VM `nixos` zostaje zamrożona w aktualnym stanie.

Porównanie shelli z gotowym wsparciem dla NixOS (stan na 2026-11-26, źródła społecznościowe):

| | DankMaterialShell (od 2.0 „Dux Shell”) | Caelestia | Noctalia v5 | hydenix | omarchy-nix |
|---|---|---|---|---|---|
| Rodzaj | sam shell | shell + dotfiles | sam shell | cały desktop | cały desktop |
| NixOS | nixpkgs 26.05, `programs.dank-material-shell.enable` | flake + moduł HM | flake/moduł `programs.noctalia` | fork społeczności | port społeczności |
| Hyprland Lua | tak (od 1.5) | tak | tak (od 4.7.7/v5) | w trakcie | tak (Omarchy 4.0) |
| GUI ustawień | rozbudowane | słabe | tak | częściowe | brak |

Wstępna rekomendacja: DMS. Jest w nixpkgs, ma panel ustawień zbliżony do GNOME i niewiele zmienia w istniejącej konfiguracji. hydenix i omarchy-nix zastępują całą konfigurację. Wszystkie shelle mają własne kolory (np. matugen), co koliduje z zasadą „kolory tylko ze Stylixa”. Na czas eksperymentu zasada nie obejmuje samego shella.

## Przebieg

- 2026-11-26: VM `nixos` wyłączona, utworzony snapshot `przed-shell` (wewnętrzny, qcow2). Powrót: `virsh -c qemu:///system snapshot-revert nixos przed-shell`.
- 2026-11-26: `virt-clone --original nixos --name nixos-shell --auto-clone` utworzył dysk `nixos-shell.qcow2` i NVRAM `nixos-shell_VARS.fd`. Nowy MAC to `52:54:00:d5:ac:73`. SPICE klona przestawiony na `127.0.0.1:5901` (`virt-xml --edit type=spice --graphics port=5901`), żeby obie VM mogły działać jednocześnie.
- 2026-11-26: `virt-sysprep --operations machine-id` uruchomiony jako `lank` kończy się błędem `Permission denied`, bo libguestfs otwiera plik obrazu bezpośrednio, a `/var/lib/libvirt/images` jest dostępne tylko dla roota. Polecenie trzeba wykonać przez `sudo`.

## Przyczyna źródłowa

Nie dotyczy (zmiana).

## Rozwiązanie

- [x] Wyłączyć `nixos` i zrobić snapshot `przed-shell`
- [x] Sklonować VM do `nixos-shell`, SPICE na porcie 5901
- [ ] Wyzerować `/etc/machine-id` w klonie (`sudo virt-sysprep ... --operations machine-id`); systemd wygeneruje nowy przy pierwszym starcie
- [ ] Uruchomić klon, odczytać IP, dodać alias `ssh nixos-shell`
- [ ] Hostname klona `nixos-shell` (`networking.hostName` w VM, `nixos-rebuild switch --flake /etc/nixos#nixos`)
- [ ] Ustalić sposób przechowywania kopii configu klona w repo (katalog lub gałąź)
- [ ] Wybrać i zainstalować shell (osobne zgłoszenie)

## Wnioski
