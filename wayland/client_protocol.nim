import client_core, util

type
  Buffer* = ptr object
  Callback* = ptr object
  Compositor* = ptr object
  DataDevice* = ptr object
  DataDeviceManager* = ptr object
  DataOffer* = ptr object
  DataSource* = ptr object
  Keyboard* = ptr object
  Output* = ptr object
  Pointer* = ptr object
  Region* = ptr object
  Registry* = ptr object
  Seat* = ptr object
  Shell* = ptr object
  ShellSurface* = ptr object
  Shm* = ptr object
  ShmPool* = ptr object
  Subcompositor* = ptr object
  Subsurface* = ptr object
  Surface* = ptr object
  Touch* = ptr object

  DisplayError* {.size: sizeof(cint).} = enum
    invalidObject
    invalidMethod
    noMemory
    implmentation

  DisplayListener* = object
    error*: proc(data: pointer, display: Display, object_id: pointer, code: uint32, message: cstring) {.cdecl.}
    deleteId*: proc(data: pointer, display: Display, id: uint32) {.cdecl.}

  RegistryListener* = object
    global*: proc(data: pointer, registry: Registry, name: uint32, iface: cstring, version: uint32) {.cdecl.}
    globalRemove*: proc(data: pointer, registry: Registry, name: uint32) {.cdecl.}

  CallbackListener* = object
    done*: proc(data: pointer, cb: Callback, callbackData: uint32) {.cdecl.}

  ShmError* {.size: sizeof(cint).} = enum
    invalidFormat
    invalidStride
    invalidFd

  ShmListener* = object
    format*: proc(data: pointer, shm: Shm, format: uint32) {.cdecl.}

  BufferListener* = object
    release*: proc(data: pointer, buf: Buffer) {.cdecl.}

  DataOfferError* {.size: sizeof(cint).} = enum
    invalidFinish
    invalidActionMask
    invalidAction
    invalidOffer

  DataOfferListener* = object
    offer*: proc(data: pointer, dataOffer: DataOffer, mimeType: cstring) {.cdecl.}
    sourceActions*: proc(data: pointer, dataOffer: DataOffer, sourceActions: uint32) {.cdecl.}
    action*: proc(data: pointer, dataOffer: DataOffer, dndAction: uint32) {.cdecl.}
  
var
  wl_display_interface {.importc.}: Interface
  wl_registry_interface {.importc.}: Interface
  wl_callback_interface {.importc.}: Interface
  wl_compositor_interface {.importc.}: Interface
  wl_shm_pool_interface {.importc.}: Interface
  wl_shm_interface {.importc.}: Interface
  wl_buffer_interface {.importc.}: Interface
  wl_data_offer_interface {.importc.}: Interface
  wl_data_source_interface {.importc.}: Interface
  wl_data_device_interface {.importc.}: Interface
  wl_data_device_manager_interface {.importc.}: Interface
  wl_shell_interface {.importc.}: Interface
  wl_shell_surface_interface {.importc.}: Interface
  wl_surface_interface {.importc.}: Interface
  wl_seat_interface {.importc.}: Interface
  wl_pointer_interface {.importc.}: Interface
  wl_keyboard_interface {.importc.}: Interface
  wl_touch_interface {.importc.}: Interface
  wl_output_interface {.importc.}: Interface
  wl_region_interface {.importc.}: Interface
  wl_subcompositor_interface {.importc.}: Interface
  wl_subsurface_interface {.importc.}: Interface

proc addListener*(d: Display, listener: ptr DisplayListener, data: pointer): cint {.inline.} =
  cast[Proxy](d).addListener(listener, data)

const
  WL_DISPLAY_SYNC* = 0
  WL_DISPLAY_GET_REGISTRY* = 1
  WL_DISPLAY_ERROR_SINCE_VERSION* = 1
  WL_DISPLAY_DELETE_ID_SINCE_VERSION* = 1

  WL_DISPLAY_SYNC_SINCE_VERSION* = 1
  WL_DISPLAY_GET_REGISTRY_SINCE_VERSION* = 1


proc setUserData*(d: Display, data: pointer) {.inline.} = cast[Proxy](d).setUserData(data)
proc getUserData*(d: Display): pointer {.inline.} = cast[Proxy](d).getUserData()
proc getVersion*(d: Display): uint32 {.inline.} = cast[Proxy](d).getVersion()
proc sync*(d: Display): Callback {.inline.} =
  cast[Callback](cast[Proxy](d).marshalConstructor(WL_DISPLAY_SYNC, addr wl_callback_interface, nil))
proc getRegistry*(d: Display): Registry {.inline.} =
  cast[Registry](cast[Proxy](d).marshalConstructor(WL_DISPLAY_GET_REGISTRY, addr wl_registry_interface, nil))

proc addListener*(reg: Registry, listener: ptr RegistryListener, data: pointer): cint {.inline.} =
  cast[Proxy](reg).addListener(listener, data)

const
  WL_REGISTRY_BIND* = 0
  WL_REGISTRY_GLOBAL_SINCE_VERSION* = 1
  WL_REGISTRY_GLOBAL_REMOVE_SINCE_VERSION* = 1
  WL_REGISTRY_BIND_SINCE_VERSION* = 1

proc setUserData*(reg: Registry, data: pointer) {.inline.} = cast[Proxy](reg).setUserData(data)
proc getUserData*(reg: Registry): pointer {.inline.} = cast[Proxy](reg).getUserData()
proc getVersion*(reg: Registry): uint32 {.inline.} = cast[Proxy](reg).getVersion()
proc destroy*(reg: Registry) {.inline.} = cast[Proxy](reg).destroy()

proc bindRegistry*(reg: Registry, name: uint32, iface: ptr Interface, version: uint32): pointer {.inline.} =
  cast[Proxy](reg).marshalConstructorVersioned(WL_REGISTRY_BIND, iface, version, name, iface.name, version, nil)


proc addListener*(reg: Callback, listener: ptr CallbackListener, data: pointer): cint {.inline.} =
  cast[Proxy](reg).addListener(listener, data)

const
  WL_CALLBACK_DONE_SINCE_VERSION* = 1

proc setUserData*(a: Callback, data: pointer) {.inline.} = cast[Proxy](a).setUserData(data)
proc getUserData*(a: Callback): pointer {.inline.} = cast[Proxy](a).getUserData()
proc getVersion*(a: Callback): uint32 {.inline.} = cast[Proxy](a).getVersion()
proc destroy*(a: Callback) {.inline.} = cast[Proxy](a).destroy()

const
  WL_COMPOSITOR_CREATE_SURFACE* = 0
  WL_COMPOSITOR_CREATE_REGION* = 1

  WL_COMPOSITOR_CREATE_SURFACE_SINCE_VERSION* = 1
  WL_COMPOSITOR_CREATE_REGION_SINCE_VERSION* = 1

proc setUserData*(a: Compositor, data: pointer) {.inline.} = cast[Proxy](a).setUserData(data)
proc getUserData*(a: Compositor): pointer {.inline.} = cast[Proxy](a).getUserData()
proc getVersion*(a: Compositor): uint32 {.inline.} = cast[Proxy](a).getVersion()
proc destroy*(a: Compositor) {.inline.} = cast[Proxy](a).destroy()

proc createSurface*(c: Compositor): Surface {.inline.} =
  cast[Surface](cast[Proxy](c).marshalConstructor(WL_COMPOSITOR_CREATE_SURFACE, addr wl_surface_interface, nil))

proc createRegion*(c: Compositor): Region {.inline.} =
  cast[Region](cast[Proxy](c).marshalConstructor(WL_COMPOSITOR_CREATE_REGION, addr wl_region_interface, nil))


const
  WL_SHM_POOL_CREATE_BUFFER* = 0
  WL_SHM_POOL_DESTROY* = 1
  WL_SHM_POOL_RESIZE* = 2

  WL_SHM_POOL_CREATE_BUFFER_SINCE_VERSION* = 1
  WL_SHM_POOL_DESTROY_SINCE_VERSION* = 1
  WL_SHM_POOL_RESIZE_SINCE_VERSION* = 1



  WL_SHM_FORMAT_ARGB8888* = 0
  WL_SHM_FORMAT_XRGB8888* = 1
  WL_SHM_FORMAT_C8* = 0x20203843
  WL_SHM_FORMAT_XBGR4444* = 0x32314258

  WL_SHM_FORMAT_XRGB4444* = 0x32315258
  WL_SHM_FORMAT_RGBX4444* = 0x32315852
  WL_SHM_FORMAT_BGRX4444* = 0x32315842

  WL_SHM_FORMAT_ARGB4444* = 0x32315241
  WL_SHM_FORMAT_ABGR4444* = 0x32314241
  WL_SHM_FORMAT_RGBA4444* = 0x32314152
  WL_SHM_FORMAT_BGRA4444* = 0x32314142
  WL_SHM_FORMAT_XRGB1555* = 0x35315258
  WL_SHM_FORMAT_XBGR1555* = 0x35314258
  WL_SHM_FORMAT_RGBX5551* = 0x35315852
  WL_SHM_FORMAT_BGRX5551* = 0x35315842
  WL_SHM_FORMAT_ARGB1555* = 0x35315241
  WL_SHM_FORMAT_ABGR1555* = 0x35314241
  WL_SHM_FORMAT_RGBA5551* = 0x35314152
  WL_SHM_FORMAT_BGRA5551* = 0x35314142
  WL_SHM_FORMAT_RGB888* = 0x34324752
  WL_SHM_FORMAT_BGR888* = 0x34324742
  WL_SHM_FORMAT_XBGR8888* = 0x34324258
  WL_SHM_FORMAT_RGBX8888* = 0x34325852
  WL_SHM_FORMAT_BGRX8888* = 0x34325842
  WL_SHM_FORMAT_ABGR8888* = 0x34324241
  WL_SHM_FORMAT_RGBA8888* = 0x34324152
  WL_SHM_FORMAT_BGRA8888* = 0x34324142

  WL_SHM_FORMAT_RGB332* = 0x38424752
  WL_SHM_FORMAT_BGR233* = 0x38524742

  WL_SHM_FORMAT_RGB565* = 0x36314752
  WL_SHM_FORMAT_BGR565* = 0x36314742
  WL_SHM_FORMAT_XRGB2101010* = 0x30335258
  WL_SHM_FORMAT_XBGR2101010* = 0x30334258
  WL_SHM_FORMAT_RGBX1010102* = 0x30335852
  WL_SHM_FORMAT_BGRX1010102* = 0x30335842
  WL_SHM_FORMAT_ARGB2101010* = 0x30335241
  WL_SHM_FORMAT_ABGR2101010* = 0x30334241
  WL_SHM_FORMAT_RGBA1010102* = 0x30334152
  WL_SHM_FORMAT_BGRA1010102* = 0x30334142
  WL_SHM_FORMAT_YUYV* = 0x56595559
  WL_SHM_FORMAT_YVYU* = 0x55595659
  WL_SHM_FORMAT_UYVY* = 0x59565955
  WL_SHM_FORMAT_VYUY* = 0x59555956
  WL_SHM_FORMAT_AYUV* = 0x56555941
  WL_SHM_FORMAT_NV12* = 0x3231564e
  WL_SHM_FORMAT_NV21* = 0x3132564e
  WL_SHM_FORMAT_NV16* = 0x3631564e
  WL_SHM_FORMAT_NV61* = 0x3136564e
  WL_SHM_FORMAT_YUV410* = 0x39565559
  WL_SHM_FORMAT_YVU410* = 0x39555659
  WL_SHM_FORMAT_YUV411* = 0x31315559
  WL_SHM_FORMAT_YVU411* = 0x31315659
  WL_SHM_FORMAT_YUV420* = 0x32315559
  WL_SHM_FORMAT_YVU420* = 0x32315659
  WL_SHM_FORMAT_YUV422* = 0x36315559
  WL_SHM_FORMAT_YVU422* = 0x36315659
  WL_SHM_FORMAT_YUV444* = 0x34325559
  WL_SHM_FORMAT_YVU444* = 0x34325659


proc setUserData*(a: ShmPool, data: pointer) {.inline.} = cast[Proxy](a).setUserData(data)
proc getUserData*(a: ShmPool): pointer {.inline.} = cast[Proxy](a).getUserData()
proc getVersion*(a: ShmPool): uint32 {.inline.} = cast[Proxy](a).getVersion()

proc createBuffer*(s: ShmPool, offset, width, height, stride: int32, format: uint32): Buffer {.inline.} =
  cast[Buffer](cast[Proxy](s).marshalConstructor(WL_SHM_POOL_CREATE_BUFFER, addr wl_buffer_interface, nil, offset, width, height, stride, format))

proc destroy*(s: ShmPool) {.inline.} =
  cast[Proxy](s).marshal(WL_SHM_POOL_DESTROY)
  cast[Proxy](s).destroy()

proc resize*(s: ShmPool, size: int32) {.inline.} = cast[Proxy](s).marshal(WL_SHM_POOL_RESIZE, size)

proc addListener*(a: Shm, listener: ptr ShmListener, data: pointer): cint {.inline.} =
  cast[Proxy](a).addListener(listener, data)


const
  WL_SHM_CREATE_POOL* = 0
  WL_SHM_FORMAT_SINCE_VERSION* = 1
  WL_SHM_CREATE_POOL_SINCE_VERSION* = 1

proc setUserData*(a: Shm, data: pointer) {.inline.} = cast[Proxy](a).setUserData(data)
proc getUserData*(a: Shm): pointer {.inline.} = cast[Proxy](a).getUserData()
proc getVersion*(a: Shm): uint32 {.inline.} = cast[Proxy](a).getVersion()
proc destroy*(a: Shm) {.inline.} = cast[Proxy](a).destroy()

proc createPool*(s: Shm, fd: int32, size: int32): ShmPool {.inline.} =
  cast[ShmPool](cast[Proxy](s).marshalConstructor(WL_SHM_CREATE_POOL, addr wl_shm_pool_interface, nil, fd, size))


proc addListener*(a: Buffer, listener: ptr BufferListener, data: pointer): cint {.inline.} =
  cast[Proxy](a).addListener(listener, data)

const
  WL_BUFFER_DESTROY* = 0
  WL_BUFFER_RELEASE_SINCE_VERSION* = 1
  WL_BUFFER_DESTROY_SINCE_VERSION* = 1

proc setUserData*(a: Buffer, data: pointer) {.inline.} = cast[Proxy](a).setUserData(data)
proc getUserData*(a: Buffer): pointer {.inline.} = cast[Proxy](a).getUserData()
proc getVersion*(a: Buffer): uint32 {.inline.} = cast[Proxy](a).getVersion()

proc destroy*(s: Buffer) {.inline.} =
  cast[Proxy](s).marshal(WL_BUFFER_DESTROY)
  cast[Proxy](s).destroy()


proc addListener*(a: DataOffer, listener: ptr DataOfferListener, data: pointer): cint {.inline.} =
  cast[Proxy](a).addListener(listener, data)

const
  WL_DATA_OFFER_ACCEPT* = 0
  WL_DATA_OFFER_RECEIVE* = 1
  WL_DATA_OFFER_DESTROY* = 2
  WL_DATA_OFFER_FINISH* = 3
  WL_DATA_OFFER_SET_ACTIONS* = 4
  WL_DATA_OFFER_OFFER_SINCE_VERSION* = 1
  WL_DATA_OFFER_SOURCE_ACTIONS_SINCE_VERSION* = 3
  WL_DATA_OFFER_ACTION_SINCE_VERSION* = 3

  WL_DATA_OFFER_ACCEPT_SINCE_VERSION* = 1
  WL_DATA_OFFER_RECEIVE_SINCE_VERSION* = 1
  WL_DATA_OFFER_DESTROY_SINCE_VERSION* = 1
  WL_DATA_OFFER_FINISH_SINCE_VERSION* = 3
  WL_DATA_OFFER_SET_ACTIONS_SINCE_VERSION* = 3

proc setUserData*(a: DataOffer, data: pointer) {.inline.} = cast[Proxy](a).setUserData(data)
proc getUserData*(a: DataOffer): pointer {.inline.} = cast[Proxy](a).getUserData()
proc getVersion*(a: DataOffer): uint32 {.inline.} = cast[Proxy](a).getVersion()

proc accept*(d: DataOffer, serial: uint32, mimeType: cstring) {.inline.} =
  cast[Proxy](d).marshal(WL_DATA_OFFER_ACCEPT, serial, mimeType)

proc receive*(d: DataOffer, mimeType: cstring, fd: int32) {.inline.} =
  cast[Proxy](d).marshal(WL_DATA_OFFER_RECEIVE, mimeType, fd)

proc destroy*(d: DataOffer) {.inline.} =
  cast[Proxy](d).marshal(WL_DATA_OFFER_DESTROY)
  cast[Proxy](d).destroy()

proc finish*(d: DataOffer) {.inline.} =
  cast[Proxy](d).marshal(WL_DATA_OFFER_FINISH)

proc setAction*(d: DataOffer, dndActions, preferredAction: uint32) {.inline.} =
  cast[Proxy](d).marshal(WL_DATA_OFFER_SET_ACTIONS, dndActions, preferredAction)
