---
id: 2026-11-25-03
tytul: Wspólny schowek host-VM (SPICE)
status: nowe
typ: zmiana
priorytet: niski
otwarte: 2026-11-25
zamkniete:
przyczyna:
powiazane: [2026-11-25-01]
---

## Opis

Między hostem a VM nie ma wspólnego schowka. Tekst był przenoszony przez OCR i zawierał błędy. Obejście, które już działa: `ssh nixos` i `scp`.

## Diagnoza

- Hypervisor to KVM/QEMU (`systemd-detect-virt` = `kvm`), sieć libvirt `default`.
- `services.spice-vdagentd.enable = true;` obsługuje schowek X11. Pod Hyprlandem (Wayland) zadziała najwyżej częściowo, przez XWayland. Pełne działanie może wymagać mostka wl-clipboard ↔ X11.

## Rozwiązanie

- [ ] Sprawdzić, czy VM ma kanał `spicevmc` i wyświetlacz SPICE
- [ ] `services.spice-vdagentd.enable = true;` i test kopiowania w obie strony
- [ ] Jeśli nie działa pod Wayland: ocenić mostek (np. clipsync) albo zostać przy SSH

## Wnioski
