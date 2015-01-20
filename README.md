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

1. Install [MSYS2](https://msys2.github.io) and upgrade your installation (be sure to follow the [instructions](http://sourceforge.net/p/msys2/wiki/MSYS2%20installation/)).
2. Clone the app-packages repository (or download a snapshot).
3. Run MSYS2 shell. It's better if you clean your `PATH` so it contains only msys (but not mingw) and Windows system directories. You can do it this way:
  1. Open a command prompt.
  2. Run `set PATH=%SystemRoot%\System32;%SystemRoot%`.
  3. Run `C:\msys64\msys2_shell.bat` (change this path if you installed MSYS2 elsewhere).
4. Enter the directory of the package you want to create.
5. Run `makepkg`.
  - If it complains about missing dependencies, install them with `pacman`.
6. Enjoy. You can install the package by running `pacman -U <pkgfile>.pkg.tar.xz`.

Guidelines for recipes
----------------------
- Follow MSYS2 (and Arch Linux) guidelines except where stated otherwise.
- Follow the style set in existing recipes.
- 32-bit and 64-bit package versions are separate and should still work if only one of them is installed.
- De-duplication takes place only on the level of whole applications, e.g. every package includes its own OpenSSL library, if it needs one, but a TeX editor and a TeX distribution should be separate packages.
- Include all available localizations.
- All documentation, examples and help files go into a separate directory.
- User configuration goes into per-user directories.
- Do not include auto-updaters and uninstallers.
- Do not include copies of system libraries, e.g. `msvc*.dll`, `mfc*.dll`, `atl*.dll`.
