---
id: 2026-11-25-05
tytul: Wolny obraz VM w virt-viewerze: QXL → virtio-gpu z virgl
status: w-toku
typ: zmiana
priorytet: sredni
otwarte: 2026-11-25
zamkniete:
przyczyna:
powiazane: [2026-11-25-03]
---

## Objawy

Praca przez virt-viewer jest ospała: wpisany znak pojawia się z opóźnieniem ok. 0,1 s.

## Diagnoza

- 2026-11-25: Karta graficzna VM to `qxl` (log Hyprlanda: `drm: Starting backend for /dev/dri/card1, with driver qxl`). QXL nie daje OpenGL, więc Hyprland i kitty renderują przez llvmpipe (OpenGL na CPU).
- VM ma 2 vCPU (host: 12 wątków). Hyprland zużywa stale ok. 10% CPU w spoczynku. RAM i load w normie.
- SPICE przez TCP `127.0.0.1:5900`, bez GL: każda klatka idzie jako obraz.
- Host: NVIDIA RTX 3060 Mobile, sterownik 550.163.01, jedyne GPU (`/dev/dri/renderD128`). Jest `nvidia-drm_gbm.so`, QEMU ma `virtio-vga-gl`.
- Kopia definicji przed zmianą: `vm/nixos-domain-przed-virgl.xml`.
- Wariant A (`virtio` + `accel3d`, SPICE `listen none` + `gl enable=yes`, 4 vCPU): VM startuje, ale `virt-viewer --attach` pokazuje tylko „Connected to graphic server”, bez obrazu. Znany problem SPICE GL ze sterownikiem NVIDII.
- Wariant B (`egl-headless` z rendernode `/dev/dri/renderD128` + SPICE na `127.0.0.1:5900` bez GL): obraz jest, praca zauważalnie płynniejsza (ocena użytkownika).
- Log Hyprlanda w gościu: `driver virtio_gpu`, `Renderer: virgl (LLVMPIPE (LLVM 19.1.7, 256 bits))`. Gość używa virgl, ale virglrenderer w QEMU na hoście renderuje przez llvmpipe zamiast przez NVIDIĘ. Poprawa wynika z 4 vCPU i z przeniesienia llvmpipe na hosta (12 wątków).
- Hipoteza do sprawdzenia: cgroup urządzeń libvirt (`cgroup_device_acl` w `/etc/libvirt/qemu.conf`) przepuszcza tylko rendernode, a nie `/dev/nvidia*`, więc EGL NVIDII w procesie QEMU się nie inicjuje i Mesa przechodzi na llvmpipe.

## Przyczyna źródłowa

Brak akceleracji 3D w gościu: QXL + llvmpipe na 2 vCPU.

## Rozwiązanie

- [x] Kopia XML domeny
- [x] Wariant A (bez obrazu, wycofany): `video virtio accel3d=yes`, SPICE `listen none` + `gl enable=yes rendernode=/dev/dri/renderD128`, 4 vCPU
- [x] Wariant B (wdrożony): `egl-headless` + zwykły SPICE
- [x] Weryfikacja: renderer `virgl` w gościu, ocena płynności (lepiej)
- [ ] Renderowanie na NVIDII hosta zamiast llvmpipe (sprawdzić hipotezę z cgroup / `qemu.conf`; wymaga sudo na hoście)
- [x] README

Powrót: `virsh -c qemu:///system define vm/nixos-domain-przed-virgl.xml` (przy wyłączonej VM).

## Wnioski
