# CLAUDE.md

@~/LLM-workspace/ai/zasady/profile/zgloszenia.md

## Projekt

Wstępna konfiguracja NixOS + Hyprland na maszynie wirtualnej (KVM). Cel: dopracować konfigurację przed migracją prywatnego laptopa z Debiana.

- Dostęp do VM: `ssh nixos` (alias w `~/.ssh/config` hosta, użytkownik `lank`, tylko klucz).
- **Domyślny sposób pracy (także w trybie DEV):** przedstaw plan lub instrukcję, którą użytkownik wykona sam w VM. SSH służy tylko do diagnostyki (polecenia tylko do odczytu). Bez zmian w VM: bez edycji plików, `nixos-rebuild`, `hyprctl dispatch`/`reload`, uruchamiania i zabijania procesów, chyba że użytkownik wprost o to poprosi. Zmiany w repo (kopie, README, zgłoszenia) wolno robić normalnie.
- Repo: `git@github.com:LaNk314/nixOSxHyprland.git`, gałąź `main`.
- `nixos/` (= `/etc/nixos`) i `dotfiles/` (= `~`, ta sama struktura katalogów) to **kopie** plików z VM. Źródłem prawdy jest VM, dopóki nie zostanie ustalone inaczej. Po zmianie w VM odśwież kopię (polecenia w `README.md`, Backup).
- Hyprland ≥0.55 ma konfigurację w **Lua** (`~/.config/hypr/hyprland.lua`, `hl.monitor`, `hl.bind`, `hl.on("hyprland.start", …)`). Nie podawaj składni hyprlang (`hyprland.conf`, `exec-once`, `monitor=`). W razie wątpliwości sprawdź na wiki.hypr.land.
- Kolory tylko z palety Stylix (`nixos/stylix.nix`, pliki `colors.*` generowane w `nixos/home.nix`). W configach nie wpisuj wartości hex, używaj nazw base16 (README, Szybki start). Home Manager nie przejmuje ręcznie edytowanych dotfiles.
- Użytkownik dopiero poznaje NixOS: tłumacz krótko, dlaczego coś robimy.

- `README.md`: aktualny stan systemu, bez historii.
- `zgloszenia/` + `DZIENNIK.md`: zgłoszenia zgodnie z profilem powyżej.
- Każde otwarcie i zamknięcie zgłoszenia od razu commituj i pushuj (`main`), razem z powiązanymi zmianami w repo. Dotyczy to wszystkich trybów.
