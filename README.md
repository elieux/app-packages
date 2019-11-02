App Packages
======================

This is a set of PKGBUILD-based recipes for downloading and packaging free Windows software. It integrates with [MSYS2](https://msys2.github.io) and its package manager pacman (ported from Arch Linux).

Disclaimer
----------

I'm not a lawyer and I'm definitely not familiar with the laws of every country, so the claims I make here about licenses and copyright may be not applicable to you or just plain wrong. I'm not responsible for any damage or lawsuits based on using this repository.

License
-------

The recipes are free to use and modify by anyone, but I'd be glad if all improvements make it to my repository. If you need a specific license, create a ticket or contact me.

The applications are under various licenses, including both OSI-certified licenses and EULAs. Hopefully, no license can prevent making these recipes.

Binaries
--------

There will never be a public repository with built packages because many licenses forbid re-distributing binaries. You can make a private binary repository for yourself though.

Building
--------

1. Install [MSYS2](https://msys2.org) and upgrade your installation.
2. Clone the `app-packages` repository (or download a snapshot).
3. Run MSYS2 shell. It's better if you clean your `PATH` so it contains only msys (but not mingw) and Windows system directories. You can do it this way:
  1. Open a command prompt.
  2. Run `set PATH=%SystemRoot%\System32;%SystemRoot%;%SystemRoot%\System32\Wbem`.
  3. Run `C:\msys64\msys2_shell.bat` (change this path if you installed MSYS2 elsewhere).
4. Enter the directory of the package you want to create.
5. Run `makepkg`.
  - If it complains about missing dependencies, install them with `pacman`.
6. Enjoy. You can install the package by running `pacman -U <pkgfile>.pkg.tar.xz`.

Guidelines for recipes
----------------------

- Follow MSYS2 and Arch Linux guidelines except where stated otherwise.
- Follow the style set in existing recipes.
- 32-bit and 64-bit package versions are separate and should still work if only one of them is installed.
- De-duplication takes place only on the level of whole applications, e.g. every package includes its own OpenSSL library, if it needs one, but a TeX editor and a TeX distribution should be separate packages.
- Include all available localizations.
- User configuration goes into per-user directories.
- Do not include auto-updaters and uninstallers.
- Do not include copies of Microsoft re-distributable libraries, e.g. `msvc*.dll`, `mfc*.dll`, `atl*.dll`. `msvb*.dll`.
- If the URL in `$source` doesn't use `$pkgver`, create a `pkgver()` function.
- `prepare()` is for extracting and various file manipulations; anything complex like silent installs go into `build()`.
- Know that the working directory is set to `$srcdir` and don't change it much.
- Use quotes and braces.
- Indent code using 4 spaces.
- Use aliases in `$source` and don't leave version numbers in them.
- Try to copy everything in `package()` and then move or delete what's necessary. This way, if there's a new file upstream, it won't get overlooked.

References for recipes
----------------------

- `man PKGBUILD` in MSYS2 shell
- [Creating packages](https://github.com/msys2/msys2/wiki/Creating-packages) on MSYS2 wiki
- [PKGBUILD](https://wiki.archlinux.org/index.php/PKGBUILD) on ArchWiki
- [Creating packages](https://wiki.archlinux.org/index.php/Creating_packages) on ArchWiki
- [Arch packaging standards](https://wiki.archlinux.org/index.php/Arch_packaging_standards) on ArchWiki
