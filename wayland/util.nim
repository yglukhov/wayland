
type
  Message* = object
    name*: cstring
    signature*: cstring
    types*: ptr ptr Interface

  Interface* = object
    name*: cstring
    version*: cint
    methodCount*: cint
    methods*: ptr Message
    eventCount*: cint
    events*: ptr Message

  Fixed* = distinct int32
  Object* = ptr object
  Array* = object
    size*: csize
    alloc*: csize
    data*: pointer

  Argument* = object {.union.}
    i*: int32
    u*: uint32
    f*: Fixed
    s*: cstring
    o*: Object
    n*: uint32
    a*: ptr Array
    h*: int32

  List*[T] = object
    prev*, next*: ptr List[T]

  DispatcherFunc* = proc(a: pointer, b: pointer, u: uint32, m: ptr Message, args: ptr Argument) {.cdecl.}
  # LogFunc* = proc(fmt: cstring, args: pointer) {.cdecl.}
