---
id: 2026-11-25-04
tytul: Plan migracji prywatnego laptopa z Debiana na NixOS + Hyprland
status: nowe
typ: ustalenie
priorytet: sredni
otwarte: 2026-11-25
zamkniete:
przyczyna:
powiazane: [2026-11-25-01, 2026-11-25-02]
---

## Opis

Docelowo konfiguracja z VM ma trafić na prywatny laptop, który obecnie działa na Debianie. Zgłoszenie zbiera, co trzeba ustalić przed migracją.

## Do ustalenia

- [ ] Inwentaryzacja Debiana: zainstalowane programy, usługi, dane w `~`, klucze SSH/GPG, konfiguracje (dotfiles)
- [ ] Sprzęt laptopa: GPU (sterowniki pod Hyprland), Wi-Fi, Bluetooth, podświetlenie, touchpad, zarządzanie energią (np. `services.power-profiles-daemon` lub `tlp`)
- [ ] Partycjonowanie i szyfrowanie dysku (LUKS?), swap, hibernacja
- [ ] Struktura configu: jeden `configuration.nix` czy moduły, flakes czy kanały, Home Manager dla dotfiles
- [ ] Backup danych z Debiana i test odtworzenia przed instalacją
- [ ] Brakujące elementy środowiska: blokada ekranu (hyprlock + hypridle), polkit agent, Bluetooth/sieć w waybarze, układ klawiatury PL

## Wnioski
