# Package

version       = "0.1.0"
author        = "Andrew Burns"
description   = "Nim bindings for libchamplain."
license       = "LGPLv2.1"
srcDir        = "src"

# Dependencies

requires "nim >= 0.18.0"
requires "nimclutter >= 0.1.0"
requires "oldgtk3"

import distros

when defined(nimdistros):
  foreignDep "glib"
  foreignDep "gio"
  foreignDep "gdk"
  foreignDep "cairo"
  foreigndep "clutter"
  foreigndep "sqlite"
  foreigndep "libsoup"
  foreigndep "gtk"