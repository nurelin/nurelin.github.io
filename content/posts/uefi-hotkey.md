+++
title = "Hotkeying OSes in UEFI Boot"
date = 2025-11-29
[taxonomies]
tags = [ "UEFI", "BIOS" ]
+++

If you are multi-booting OSes on your computer and would like to speed up
the boot by hotkeying your OSes rather than waiting for a bootloader, 
there might be a way even without direct manufacturer support.

<!-- more -->

The UEFI specification describes [a system to allow hotkey boot entries](https://uefi.org/specs/UEFI/2.11/03_Boot_Manager.html#launching-boot-load-options-using-hot-keys).
The system is optional but since most if not all UEFI systems are based on 
the open-source edk2 which implements it, I expect that most systems have 
it even if it is not exposed.

The UEFI variable `BootOptionSupport` is a bitwise OR of multiple capabilities of the UEFI BIOS.
The one we are interested in is defined as 

```C
#define EFI_BOOT_OPTION_SUPPORT_KEY         0x00000001
```

So we need to check if our BIOS does support it:
```bash
$ if test $(($(od -An -tu8 /sys/firmware/efi/efivars/BootOptionSupport-*) & 1)); then echo "Hotkey supported !"; else echo "Hotkey unavailable"; fi
Hotkey supported !
```

Great! Now we need to actually hotkey our OSes.

Like most aspects of UEFI, the boot process is controlled through UEFI variables.
For example, all of the OSes your firmware knows and can boot are contained in the `BootXXXX` variables.
The issue is that the content of those variables is a C struct that is rather difficult to manipulate with shell tools.

```bash
$ cat /sys/firmware/efi/efivars/Boot0001-8be4df61-93ca-11d2-aa0d-00e098032b8c    
tLinux Boot Manager*"����^��Z�A���▒yP�qF\EFI\systemd\systemd-bootx64.efi�****
```

Now we want to create a `Key####` variable which has its own [C-struct](https://uefi.org/specs/UEFI/2.11/03_Boot_Manager.html#launching-boot-load-options-using-hot-keys) 
to refer both to the Boot Entry and to the key you want to associate. 

I do not want to go too deep in the specific process here but you have a few ways to do it.
The easiest would be to use a graphical tool like [efibooteditor](https://github.com/Neverous/efibooteditor).
We could alternatively try to edit the UEFI variables in `/sys/firmware/efi/efivars/` ourselves but that seems like too much work to do it safely.
I personally went with the [UEFI shell](https://uefi.org/sites/default/files/resources/UEFI_Shell_Spec_2_0.pdf) and [bcfg command](https://uefi.org/sites/default/files/resources/UEFI_Shell_Spec_2_0.pdf#%5B%7B%22num%22%3A1582%2C%22gen%22%3A0%7D%2C%7B%22name%22%3A%22XYZ%22%7D%2C0%2C792%2Cnull%5D) route.

But in the end, even if the capability is not exposed in the BIOS menu, you might still be able to use it!
