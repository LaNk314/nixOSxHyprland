---
id: 2026-11-25-02
tytul: Porządki w konfiguracji po pierwszym przeglądzie
status: nowe
typ: zmiana
priorytet: sredni
otwarte: 2026-11-25
zamkniete:
przyczyna:
powiazane: [2026-11-25-01]
---

## Opis

Przegląd `configuration.nix` i `hyprland.lua` przez SSH (2026-11-25) wykazał niespójności. Żadna nie blokuje pracy.

## Diagnoza

1. **Nautilus bez gvfs:** brak `services.gvfs.enable = true;`, więc kosz, montowanie nośników i lokalizacje sieciowe nie działają.
2. **Dwa launchery:** zainstalowane są `wofi` i `fuzzel`, a używany jest tylko fuzzel (SUPER+D).
3. **Zmienne z wygenerowanego configu wskazują niezainstalowane programy:** `fileManager = "dolphin"` i `menu = "hyprlauncher"` (`hyprland.lua`, sekcja MY PROGRAMS). Przez to:
   - SUPER+R (`menu`) nic nie uruchamia,
   - SUPER+E jest przypisany dwukrotnie: `mainMod + E` → dolphin (l. 269) i `SUPER+E` → nautilus (l. 377).
4. **Skróty bez narzędzi:** `brightnessctl` i `playerctl` nie są zainstalowane. W VM jasność i tak nie działa, ale na laptopie będzie potrzebna.
5. **Pusty `~/.config/kitty/`:** kitty działa na ustawieniach domyślnych.
6. W `hyprland.lua` zostały komentarze z wygenerowanego configu i zakomentowany przykład autostartu. To kosmetyka.

## Rozwiązanie

- [ ] `services.gvfs.enable = true;` (+ ewentualnie `services.tumbler.enable` dla miniatur)
- [ ] Usunąć `wofi` z `systemPackages` albo świadomie go zostawić
- [ ] W `hyprland.lua`: `fileManager = "nautilus"`, `menu = "fuzzel"`, usunąć zdublowane `SUPER+E`/`SUPER+D` z końca pliku
- [ ] Dodać `brightnessctl` i `playerctl` (przed migracją na laptopa)
- [ ] `sudo nixos-rebuild switch`, odświeżyć kopie w repo

## Wnioski
