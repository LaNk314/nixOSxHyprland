# CLAUDE.md

@~/LLM-workspace/ai/zasady/profile/zgloszenia.md

## Projekt

Wstępna konfiguracja NixOS + Hyprland na maszynie wirtualnej (KVM). Cel: dopracować konfigurację przed migracją prywatnego laptopa z Debiana.

- Dostęp do VM: `ssh nixos` (alias w `~/.ssh/config` hosta, użytkownik `lank`, tylko klucz). Polecenia tylko do odczytu wolno uruchamiać bezpośrednio. Zmiany w VM, takie jak `nixos-rebuild` czy edycja plików, wymagają trybu DEV.
- Repo: `git@github.com:LaNk314/nixOSxHyprland.git`, gałąź `main`.
- `nixos/` (= `/etc/nixos`) i `dotfiles/` (= `~`, ta sama struktura katalogów) to **kopie** plików z VM. Źródłem prawdy jest VM, dopóki nie zostanie ustalone inaczej. Po zmianie w VM odśwież kopię (polecenia w `README.md`, Backup).
- Hyprland ≥0.55 ma konfigurację w **Lua** (`~/.config/hypr/hyprland.lua`, `hl.monitor`, `hl.bind`, `hl.on("hyprland.start", …)`). Nie podawaj składni hyprlang (`hyprland.conf`, `exec-once`, `monitor=`). W razie wątpliwości sprawdź na wiki.hypr.land.
- Użytkownik dopiero poznaje NixOS: tłumacz krótko, dlaczego coś robimy.

- `README.md`: aktualny stan systemu, bez historii.
- `zgloszenia/` + `DZIENNIK.md`: zgłoszenia zgodnie z profilem powyżej.
