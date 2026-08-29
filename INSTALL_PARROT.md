# Instalar Parrot en el SSD externo (desde cero)

Guía para dejar Parrot instalado en un **SSD SATA por USB 3.0**, arrancable en el
**HP Victus** (i7-11 / RTX 3060), **sin tocar el Windows** del disco interno.

> El install NO se hace desde una VM: Windows solo sirve para preparar el
> pendrive instalador; la instalación se hace arrancando ese pendrive en el
> Victus, bare-metal. **No hace falta formatear el SSD antes** — el instalador
> lo formatea. Solo asegúrate de que el SSD no tenga nada que quieras conservar.

---

## Parte 1 — En Windows (preparar el instalador)

1. Descarga la ISO de **Parrot Security** (trae las herramientas) desde
   `https://parrotsec.org`. Copia también su **hash SHA256** de la web.
2. **Verifica el hash** (es una distro de seguridad, vale la pena). En PowerShell:
   ```powershell
   Get-FileHash "ruta\Parrot-security.iso" -Algorithm SHA256
   ```
   Debe coincidir con el de la web.
3. Consigue un **pendrive aparte (>=8 GB)** solo para el instalador — **se borra**.
   El SSD grande es el *destino*, no el instalador.
4. Graba la ISO al pendrive con **Rufus**: esquema **GPT**, sistema **UEFI**;
   si pregunta, modo **"DD Image"**.
5. Apaga el **Inicio rápido** de Windows: Panel de Control -> Opciones de energía
   -> "Elegir el comportamiento de los botones" -> desmarcar *Inicio rápido*.

## Parte 2 — Preparar el Victus (BIOS/UEFI)

6. Conecta **los dos**: pendrive instalador y SSD externo, en **puertos USB 3.0
   distintos**.
7. Enciende y entra al menú de arranque: HP Victus = **F9** (boot menu).
   BIOS setup = **F10** o **Esc**.
8. En BIOS: **desactiva Secure Boot** (facilita el driver NVIDIA después) y
   **Fast Boot**; deja el modo en **UEFI** (no Legacy). Guarda con **F10**.
9. En el menú **F9**, arranca desde el **pendrive instalador**.

## Parte 3 — Instalar en el SSD  ⚠️ (aquí no te puedes equivocar)

10. Arranca Parrot en Live y abre el **instalador** (Calamares).
11. En particiones: identifica el **SSD externo por su tamaño y modelo**,
    **NO** el `nvme0n1` interno (ese es Windows).
    **Elegir el disco interno borraría Windows.**
12. **Bootloader (GRUB):** instálalo en el **disco externo** (su propia partición
    EFI), **no** en el interno. Así Windows queda intacto y arrancas Parrot solo
    cuando el SSD está conectado y lo eliges en F9.
13. Termina, reinicia y **quita el pendrive** (deja el SSD).

## Parte 4 — Primer arranque + tu setup

14. En **F9** elige el SSD -> arranca tu Parrot nuevo.
15. Aplica tu personalización:
    ```sh
    git clone https://github.com/Spectre-x46/Personalizacion-Parrot.git
    cd Personalizacion-Parrot && chmod +x install.sh && ./install.sh
    ```
16. Cierra con los 3 pasos del Victus (driver NVIDIA, refresh, batería/brillo):
    ver **[CAJAS.md](CAJAS.md)** y el **README**.

---

## Si algo falla

- **El SSD no aparece en F9 tras instalar:** casi siempre es la ruta de arranque
  *fallback*. Con el pendrive en Live, copia el cargador a la ruta genérica:
  ```sh
  sudo mkdir -p /mnt/efi && sudo mount /dev/sdXn /mnt/efi   # la particion EFI del SSD
  sudo cp -r /mnt/efi/EFI/parrot /mnt/efi/EFI/BOOT 2>/dev/null
  sudo mv /mnt/efi/EFI/BOOT/grubx64.efi /mnt/efi/EFI/BOOT/BOOTX64.EFI
  ```
- **No bootea nada de USB:** revisa que Secure Boot esté OFF y USB Boot habilitado.
- **Consejo de rendimiento:** conecta el **SSD de arranque y la tablet en puertos
  USB 3.0 distintos** (idealmente controladores distintos) para que no compitan.
