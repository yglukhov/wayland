# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import wayland/[client, util]

proc test() =
  let disp = displayConnect(nil)
  if disp.isNil:
    echo "Could not connect to wayland display"
  var reg = disp.getRegistry()
  echo reg.isNil

  proc onGlobal(data: pointer, registry: Registry, name: uint32, iface: cstring, version: uint32) {.cdecl.} =
    echo "onGlobal ", iface
    
  proc onGlobalRemove(data: pointer, registry: Registry, name: uint32) {.cdecl.} =
    echo "global remove"

  var l = RegistryListener(global: onGlobal, globalRemove: onGlobalRemove)
  echo reg.addListener(addr l, nil)

  echo disp.roundtrip()
  echo disp.roundtrip()
  echo disp.roundtrip()


  echo "Another "
  reg = disp.getRegistry()
  var l2 = RegistryListener(global: onGlobal, globalRemove: onGlobalRemove)

  echo reg.addListener(addr l2, nil)
  echo disp.roundtrip()
