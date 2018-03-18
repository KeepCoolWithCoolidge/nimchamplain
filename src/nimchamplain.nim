{.deadCodeElim: on.}

when defined(windows):
  const
    LIB_CHAMP = "libchamplain-0.12.0.dll"
    LIB_CHAMP_GTK = "libchamplain-gtk-0.12.0.dll"
elif defined(macosx):
  const 
    LIB_CHAMP = "libchamplain-0.12.0.dylib"
    LIB_CHAMP_GTK = "libchamplain-gtk-0.12.0.dylib"
else:
  const 
    LIB_CHAMP = "libchamplain-0.12.0.so(|.0)"
    LIB_CHAMP_GTK = "libchamplain-gtk-0.12.0.so(|.0)"

{.pragma: libchamp, cdecl, dynlib: LIB_CHAMP.}
{.pragma: libchampgtk, cdecl, dynlib: LIB_CHAMP_GTK.}

import oldgtk3/[gobject, glib, cairo, pango, gtk]
import semver
import clutter

const
  CHAMPLAIN_MIN_LATITUDE* = -85.0511287798
  CHAMPLAIN_MAX_LATITUDE* = 85.0511287798
  CHAMPLAIN_MIN_LONGITUDE* = -180.0
  CHAMPLAIN_MAX_LONGITUDE* = 180.0
  CHAMPLAIN_VERSION* = newVersion(0,12,17)
  CHAMPLAIN_VERSION_S* = "0.12.17"
  CHAMPLAIN_VERSION_HEX* = ((CHAMPLAIN_VERSION.major shl 24) or
      (CHAMPLAIN_VERSION.minor shl 16) or (CHAMPLAIN_VERSION.patch shl 8))

when not defined(GTK_DISABLE_DEPRECATED):
  const
    CHAMPLAIN_MAP_SOURCE_OSM_OSMARENDER* = "osm-osmarender"
    CHAMPLAIN_MAP_SOURCE_OAM* = "OpenAerialMap"
    CHAMPLAIN_MAP_SOURCE_OSM_MAPQUEST* = "osm-mapquest"
    CHAMPLAIN_MAP_SOURCE_OSM_AERIAL_MAP* = "osm-aerialmap"
const
  CHAMPLAIN_MAP_SOURCE_OSM_MAPNIK* = "osm-mapnik"
  CHAMPLAIN_MAP_SOURCE_OSM_CYCLE_MAP* = "osm-cyclemap"
  CHAMPLAIN_MAP_SOURCE_OSM_TRANSPORT_MAP* = "osm-transportmap"
  CHAMPLAIN_MAP_SOURCE_MFF_RELIEF* = "mff-relief"
  CHAMPLAIN_MAP_SOURCE_OWM_CLOUDS* = "owm-clouds"
  CHAMPLAIN_MAP_SOURCE_OWM_PRECIPITATION* = "owm-precipitation"
  CHAMPLAIN_MAP_SOURCE_OWM_PRESSURE* = "owm-pressure"
  CHAMPLAIN_MAP_SOURCE_OWM_WIND* = "owm-wind"
  CHAMPLAIN_MAP_SOURCE_OWM_TEMPERATURE* = "owm-temperature"
when defined(CHAMPLAIN_HAS_MEMPHIS):
  const
    CHAMPLAIN_MAP_SOURCE_MEMPHIS_LOCAL* = "memphis-local"
    CHAMPLAIN_MAP_SOURCE_MEMPHIS_NETWORK* = "memphis-network"

type
  DebugFlags* {.size: sizeof(cint), pure.} = enum
    CHAMPLAIN_DEBUG_LOADING = 1 shl 1, CHAMPLAIN_DEBUG_ENGINE = 1 shl 2,
    CHAMPLAIN_DEBUG_VIEW = 1 shl 3, CHAMPLAIN_DEBUG_NETWORK = 1 shl 4,
    CHAMPLAIN_DEBUG_CACHE = 1 shl 5, CHAMPLAIN_DEBUG_SELECTION = 1 shl 6,
    CHAMPLAIN_DEBUG_MEMPHIS = 1 shl 7, CHAMPLAIN_DEBUG_OTHER = 1 shl 8
  SelectionMode* {.size: sizeof(cint), pure.} = enum
    CHAMPLAIN_SELECTION_NONE, CHAMPLAIN_SELECTION_SINGLE,
    CHAMPLAIN_SELECTION_MULTIPLE
  MemphisRuleType* {.size: sizeof(cint), pure.} = enum
    CHAMPLAIN_MEMPHIS_RULE_TYPE_UNKNOWN, CHAMPLAIN_MEMPHIS_RULE_TYPE_NODE,
    CHAMPLAIN_MEMPHIS_RULE_TYPE_WAY, CHAMPLAIN_MEMPHIS_RULE_TYPE_RELATION
  Unit* {.size: sizeof(cint), pure.} = enum
    CHAMPLAIN_UNIT_KM, CHAMPLAIN_UNIT_MILES
  State* {.size: sizeof(cint), pure.} = enum
    CHAMPLAIN_STATE_NONE, CHAMPLAIN_STATE_LOADING, CHAMPLAIN_STATE_LOADED,
    CHAMPLAIN_STATE_DONE
  MapProjection* {.size: sizeof(cint), pure.} = enum
    CHAMPLAIN_MAP_PROJECTION_MERCATOR

type
  AdjustmentPrivateObj*  = object
  AdjustmentPrivate* = ptr AdjustmentPrivateObj
  Adjustment* = ptr AdjustmentObj
  AdjustmentObj*  = object
    parent_instance*: GObject
    priv*: ptr AdjustmentPrivateObj
  AdjustmentClass* = ptr AdjustmentClassObj
  AdjustmentClassObj*  = object
    parent_class*: GObjectClass
    changed*: proc (adjustment: Adjustment)
  BoundingBox* = ptr BoundingBoxObj
  BoundingBoxObj*  = object
    left*: cdouble
    top*: cdouble
    right*: cdouble
    bottom*: cdouble
  CoordinatePrivate* = ptr CoordinatePrivateObj
  CoordinatePrivateObj*  = object
  Coordinate*  = object
    parent*: GInitiallyUnowned
    priv*: CoordinatePrivate
  CoordinateClass* = ptr CoordinateClassObj
  CoordinateClassObj*  = object
    parent_class*: GInitiallyUnownedClass
  CustomMarkerPrivate* = ptr CustomMarkerPrivateObj
  CustomMarkerPrivateObj*  = object
  CustomMarker*  = ptr CustomMarkerObj
  CustomMarkerObj*  = object
    parent*: MarkerObj
    priv*: CustomMarkerPrivate
  CustomMarkerClass* = ptr CustomMarkerClassObj
  CustomMarkerClassObj*  = object
    parent_class*: MarkerClassObj
  ErrorTileRendererPrivate* = ptr ErrorTileRendererPrivateObj
  ErrorTileRendererPrivateObj*  = object
  ErrorTileRenderer*  = ptr ErrorTileRendererObj
  ErrorTileRendererObj*  = object
    parent*: RendererObj
    priv*: ErrorTileRendererPrivate
  ErrorTileRendererClass*  = ptr ErrorTileRendererClassObj
  ErrorTileRendererClassObj*  = object
    parent_class*: RendererClassObj
  Exportable*  = ptr ExportableObj
  ExportableObj*  = object
  ExportableIface*  = ptr ExportableIfaceObj
  ExportableIfaceObj*  = object
    g_iface*: GTypeInterface
    get_surface*: proc (exportable: Exportable): Surface
    set_surface*: proc (exportable: Exportable; surface: Surface)
  FileCachePrivate* = ptr FileCachePrivateObj
  FileCachePrivateObj*  = object
  FileCache* =  ptr FileCacheObj
  FileCacheObj*  = object
    parent_instance*: TileCacheObj
    priv*: FileCachePrivate
  FileCacheClass*  = ptr FileCacheClassObj
  FileCacheClassObj*  = object
    parent_class*: TileCacheClassObj
  FileTileSource*  = ptr FileTileSourceObj
  FileTileSourceObj*  = object
    parent*: TileSourceObj
  FileTileSourceClass* = ptr FileTileSourceClassObj
  FileTileSourceClassObj*  = object
    parent_class*: TileSourceClassObj
  ImageRendererPrivate* = ptr ImageRendererPrivateObj
  ImageRendererPrivateObj*  = object
  ImageRenderer*  = ptr ImageRendererObj
  ImageRendererObj*  = object
    parent*: RendererObj
    priv*: ImageRendererPrivate
  ImageRendererClass*  = ptr ImageRendererClassObj
  ImageRendererClassObj*  = object
    parent_class*: RendererClassObj
  KineticScrollViewMotion*  = ptr KineticScrollViewMotionObj
  KineticScrollViewMotionObj*  = object
    x*: cfloat
    y*: cfloat
    time*: GTimeVal
  KineticScrollViewPrivate* = ptr KineticScrollViewPrivateObj
  KineticScrollViewPrivateObj*  = object
  KineticScrollView* = ptr KineticScrollViewObj
  KineticScrollViewObj*  = object
    parent_instance*: Actor
    priv*: KineticScrollViewPrivate
  KineticScrollViewClass* = ptr KineticScrollViewClassObj
  KineticScrollViewClassObj*  = object
    parent_class*: ActorClass
  LabelPrivate*  = ptr LabelPrivateObj
  LabelPrivateObj*  = object
  Label*  = ptr LabelObj
  LabelObj*  = object
    parent*: MarkerObj
    priv*: LabelPrivate
  LabelClass*  = ptr LabelClassObj
  LabelClassObj*  = object
    parent_class*: MarkerClassObj
  Layer* = ptr LayerObj
  LayerObj*  = object
    parent*: Actor
  LayerClass* = ptr LayerClassObj
  LayerClassObj*  = object
    parent_class*: ActorClass
    set_view*: proc (layer: Layer; view: View)
    get_bounding_box*: proc (layer: Layer): BoundingBox
  LicensePrivate* = ptr LicensePrivateObj
  LicensePrivateObj*  = object
  License* = ptr LicenseObj
  LicenseObj*  = object
    parent*: Actor
    priv*: LicensePrivate
  LicenseClass* = ptr LicenseClassObj
  LicenseClassObj*  = object
    parent_class*: ActorClass
  Location* = ptr LocationObj
  LocationObj*  = object
  LocationIface* = ptr LocationIfaceObj
  LocationIfaceObj*  = object
    g_iface*: GTypeInterface
    get_latitude*: proc (location: Location): cdouble
    get_longitude*: proc (location: Location): cdouble
    set_location*: proc (location: Location; latitude: cdouble; longitude: cdouble)
  MapSourceChainPrivate* = ptr MapSourceChainPrivateObj
  MapSourceChainPrivateObj*  = object
  MapSourceChain* = ptr MapSourceChainObj
  MapSourceChainObj*  = object
    parent_instance*: MapSourceObj
    priv*: MapSourceChainPrivate
  MapSourceChainClass* = ptr MapSourceChainClassObj
  MapSourceChainClassObj*  = object
    parent_class*: MapSourceClassObj
  MapSourceConstructor* = proc (desc: MapSourceDesc): MapSource
  MapSourceDescPrivate* = ptr MapSourceDescPrivateObj
  MapSourceDescPrivateObj*  = object
  MapSourceDesc* = ptr MapSourceDescObj
  MapSourceDescObj*  = object
    parent_instance*: GObject
    priv*: MapSourceDescPrivate
  MapSourceDescClass*  = ptr MapSourceDescClassObj
  MapSourceDescClassObj*  = object
    parent_class*: GObjectClass
  MapSourceFactoryPrivate* = ptr MapSourceFactoryPrivateObj
  MapSourceFactoryPrivateObj*  = object
  MapSourceFactory* = ptr MapSourceFactoryObj
  MapSourceFactoryObj*  = object
    parent*: GObject
    priv*: MapSourceFactoryPrivate
  MapSourceFactoryClass* = ptr MapSourceFactoryClassObj
  MapSourceFactoryClassObj*  = object
    parent_class*: GObjectClass
  MapSourcePrivate*  = ptr MapSourcePrivateObj
  MapSourcePrivateObj*  = object
  MapSource* = ptr MapSourceObj
  MapSourceObj*  = object
    parent_instance*: GInitiallyUnowned
    priv*: MapSourcePrivate
  MapSourceClass* = ptr MapSourceClassObj
  MapSourceClassObj*  = object
    parent_class*: GInitiallyUnownedClass
    get_id*: proc (map_source: MapSource): cstring
    get_name*: proc (map_source: MapSource): cstring
    get_license*: proc (map_source: MapSource): cstring
    get_license_uri*: proc (map_source: MapSource): cstring
    get_min_zoom_level*: proc (map_source: MapSource): cuint
    get_max_zoom_level*: proc (map_source: MapSource): cuint
    get_tile_size*: proc (map_source: MapSource): cuint
    get_projection*: proc (map_source: MapSource): MapProjection
    fill_tile*: proc (map_source: MapSource; tile: Tile)
  MarkerLayerPrivate* = ptr MarkerLayerPrivateObj
  MarkerLayerPrivateObj*  = object
  MarkerLayer* = ptr MarkerLayerObj
  MarkerLayerObj*  = object
    parent*: LayerObj
    priv*: MarkerLayerPrivate
  MarkerLayerClass* = ptr MarkerLayerClassObj
  MarkerLayerClassObj*  = object
    parent_class*: LayerClassObj
  MarkerPrivate* = ptr MarkerPrivateObj
  MarkerPrivateObj*  = object
  Marker* = ptr MarkerObj
  MarkerObj*  = object
    parent*: Actor
    priv*: MarkerPrivate
  MarkerClass*  = ptr MarkerClassObj
  MarkerClassObj*  = object
    parent_class*: ActorClass
  MemoryCachePrivate* = ptr MemoryCachePrivateObj
  MemoryCachePrivateObj*  = object
  MemoryCache* = ptr MemoryCacheObj
  MemoryCacheObj*  = object
    parent_instance*: TileCacheObj
    priv*: MemoryCachePrivate
  MemoryCacheClass* = ptr MemoryCacheClassObj
  MemoryCacheClassObj*  = object
    parent_class*: TileCacheClassObj
  MemphisRendererPrivate* = ptr MemphisRendererPrivateObj
  MemphisRendererPrivateObj*  = object
  MemphisRenderer* = ptr MemphisRendererObj
  MemphisRendererObj*  = object
    parent*: RendererObj
    priv*: MemphisRendererPrivate
  MemphisRendererClass* = ptr MemphisRendererClassObj
  MemphisRendererClassObj*  = object
    parent_class*: RendererClassObj
  MemphisRuleAttr* = ptr MemphisRuleAttrObj
  MemphisRuleAttrObj*  = object
    z_min*: cuchar
    z_max*: cuchar
    color_red*: cuchar
    color_green*: cuchar
    color_blue*: cuchar
    color_alpha*: cuchar
    style*: cstring
    size*: cdouble
  MemphisRule* = ptr MemphisRuleObj
  MemphisRuleObj*  = object
    keys*: ptr cstring
    values*: ptr cstring
    `type`*: MemphisRuleType
    polygon*: MemphisRuleAttr
    line*: MemphisRuleAttr
    border*: MemphisRuleAttr
    text*: MemphisRuleAttr
  NetworkBboxTileSourcePrivate* = ptr NetworkBboxTileSourcePrivateObj
  NetworkBboxTileSourcePrivateObj*  = object
  NetworkBboxTileSource* = ptr NetworkBboxTileSourceObj
  NetworkBboxTileSourceObj*  = object
    parent*: TileSourceObj
    priv*: NetworkBboxTileSourcePrivate
  NetworkBboxTileSourceClass* = ptr NetworkBboxTileSourceClassObj
  NetworkBboxTileSourceClassObj*  = object
    parent_class*: TileSourceClassObj
  NetworkTileSourcePrivate* = ptr NetworkTileSourcePrivateObj
  NetworkTileSourcePrivateObj*  = object
  NetworkTileSource* = ptr NetworkTileSourceObj
  NetworkTileSourceObj*  = object
    parent_instance*: TileSourceObj
    priv*: NetworkTileSourcePrivate
  NetworkTileSourceClass* = ptr NetworkTileSourceClassObj
  NetworkTileSourceClassObj*  = object
    parent_class*: TileSourceClassObj
  NullTileSource* = ptr NullTileSourceObj
  NullTileSourceObj*  = object
    parent*: TileSourceObj
  NullTileSourceClass* = ptr NullTileSourceClassObj
  NullTileSourceClassObj*  = object
    parent_class*: TileSourceClassObj
  PathLayerPrivate* = ptr PathLayerPrivateObj
  PathLayerPrivateObj*  = object
  PathLayer* = ptr PathLayerObj
  PathLayerObj*  = object
    parent*: LayerObj
    priv*: PathLayerPrivate
  PathLayerClass* = ptr PathLayerClassObj
  PathLayerClassObj*  = object
    parent_class*: LayerClassObj
  PointPrivate* = ptr PointPrivateObj
  PointPrivateObj*  = object
  Point* = ptr PointObj
  PointObj*  = object
    parent*: MarkerObj
    priv*: PointPrivate
  PointClass* = ptr PointClassObj
  PointClassObj*  = object
    parent_class*: MarkerClassObj
  Renderer* = ptr RendererObj
  RendererObj*  = object
    parent*: GInitiallyUnowned
  RendererClass* = ptr RendererClassObj
  RendererClassObj*  = object
    parent_class*: GInitiallyUnownedClass
    set_data*: proc (renderer: Renderer; data: cstring; size: cuint)
    render*: proc (renderer: Renderer; tile: Tile)
  ScalePrivate* = ptr ScalePrivateObj
  ScalePrivateObj*  = object
  Scale* = ptr ScaleObj
  ScaleObj*  = object
    parent*: Actor
    priv*: ScalePrivate
  ScaleClass* = ptr ScaleClassObj
  ScaleClassObj*  = object
    parent_class*: ActorClass
  TileCachePrivate* = ptr TileCachePrivateObj
  TileCachePrivateObj*  = object
  TileCache* = ptr TileCacheObj
  TileCacheObj*  = object
    parent_instance*: MapSourceObj
    priv*: TileCachePrivate
  TileCacheClass* = ptr TileCacheClassObj
  TileCacheClassObj*  = object
    parent_class*: MapSourceClassObj
    store_tile*: proc (tile_cache: TileCache; tile: Tile; contents: cstring; size: Gsize)
    refresh_tile_time*: proc (tile_cache: TileCache; tile: Tile)
    on_tile_filled*: proc (tile_cache: TileCache; tile: Tile)
  TileSourcePrivate* = ptr TileSourcePrivateObj
  TileSourcePrivateObj*  = object
  TileSource* = ptr TileSourceObj
  TileSourceObj*  = object
    parent_instance*: MapSourceObj
    priv*: TileSourcePrivate
  TileSourceClass* = ptr TileSourceClassObj
  TileSourceClassObj*  = object
    parent_class*: MapSourceClassObj
  TilePrivate* = ptr TilePrivateObj
  TilePrivateObj*  = object
  Tile* = ptr TileObj
  TileObj*  = object
    parent*: Actor
    priv*: TilePrivate
  TileClass* = ptr TileClassObj
  TileClassObj*  = object
    parent_class*: ActorClass
  ViewPrivate* = ptr ViewPrivateObj
  ViewPrivateObj*  = object
  View* = ptr ViewObj
  ViewObj*  = object
    parent*: Actor
    priv*: ViewPrivate
  ViewClass* = ptr ViewClassObj
  ViewClassObj*  = object
    parent_class*: ActorClass
  ViewportPrivate* = ptr ViewportPrivateObj
  ViewportPrivateObj*  = object
  Viewport* = ptr ViewportObj
  ViewportObj*  = object
    parent*: Actor
    priv*: ViewportPrivate
  ViewportClass* = ptr ViewportClassObj
  ViewportClassObj*  = object
    parent_class*: ActorClass
  GtkEmbedPrivate* = ptr GtkEmbedPrivateObj
  GtkEmbedPrivateObj*  = object
  GtkEmbed* = ptr GtkEmbedObj
  GtkEmbedObj*  = object
    bin*: gtk.Alignment
    priv*: GtkEmbedPrivate
  GtkEmbedClass* = ptr GtkEmbedClassObj
  GtkEmbedClassObj*  = object
    parent_class*: gtk.AlignmentClass

proc newAdjustment*(value: cdouble; lower: cdouble; upper: cdouble; step_increment: cdouble): Adjustment {.importc:"champlain_adjustment_new", libchamp.}
proc getValue*(adjustment: Adjustment): cdouble {.importc:"champlain_adjustment_get_value", libchamp.}
proc setValue*(adjustment: Adjustment; value: cdouble) {.importc:"champlain_adjustment_set_value", libchamp.}
proc setValues*(adjustment: Adjustment; value: cdouble; lower: cdouble; upper: cdouble; step_increment: cdouble) {.importc:"champlain_adjustment_set_values", libchamp.}
proc getValues*(adjustment: Adjustment; value: ptr cdouble; lower: ptr cdouble; upper: ptr cdouble; step_increment: ptr cdouble) {.importc:"champlain_adjustment_get_values", libchamp.}
proc interpolate*(adjustment: Adjustment; value: cdouble; n_frames: cuint; fps: cuint) {.importc:"champlain_adjustment_interpolate", libchamp.}
proc clamp*(adjustment: Adjustment; interpolate: Gboolean; n_frames: cuint; fps: cuint): Gboolean {.importc:"champlain_adjustment_clamp", libchamp.}
proc interpolateStop*(adjustment: Adjustment) {.importc:"champlain_adjustment_interpolate_stop", libchamp.}
proc newBoundingBox*(): BoundingBox {.importc:"champlain_bounding_box_new", libchamp.}
proc copy*(bbox: BoundingBox): BoundingBox {.importc:"champlain_bounding_box_copy", libchamp.}
proc free*(bbox: BoundingBox) {.importc:"champlain_bounding_box_free", libchamp.}
proc get_center*(bbox: BoundingBox; latitude: ptr cdouble; longitude: ptr cdouble) {.importc:"champlain_bounding_box_get_center", libchamp.}
proc compose*(bbox: BoundingBox; other: BoundingBox) {.importc:"champlain_bounding_box_compose", libchamp.}
proc extend*(bbox: BoundingBox; latitude: cdouble; longitude: cdouble) {.importc:"champlain_bounding_box_extend", libchamp.}
proc isValid*(bbox: BoundingBox): Gboolean {.importc:"champlain_bounding_box_is_valid", libchamp.}
proc covers*(bbox: BoundingBox; latitude: cdouble; longitude: cdouble): Gboolean {.importc:"champlain_bounding_box_covers", libchamp.}
proc newCoordinate*(): Coordinate {.importc:"champlain_coordinate_new", libchamp.}
proc newCoordinate*(latitude: cdouble; longitude: cdouble): Coordinate {.importc:"champlain_coordinate_new_full", libchamp.}
proc newCustomMarker*(): Actor {.importc:"champlain_custom_marker_new", libchamp.}
proc flagIsSet*(flag: DebugFlags): Gboolean {.importc:"champlain_debug_flag_is_set", libchamp.}
proc debug*(flag: DebugFlags; format: cstring) {.varargs, importc:"champlain_debug", libchamp.}
proc setFlags*(flags_string: cstring) {.importc:"champlain_debug_set_flags", libchamp.}
proc newErrorTileRenderer*(tile_size: cuint): ErrorTileRenderer {.importc:"champlain_error_tile_renderer_new", libchamp.}
proc setTileSize*(renderer: ErrorTileRenderer; size: cuint) {.importc:"champlain_error_tile_renderer_set_tile_size", libchamp.}
proc getTileSize*(renderer: ErrorTileRenderer): cuint {.importc:"champlain_error_tile_renderer_get_tile_size", libchamp.}
proc setSurface*(exportable: Exportable; surface: Surface) {.importc:"champlain_exportable_set_surface", libchamp.}
proc getSurface*(exportable: Exportable): Surface {.importc:"champlain_exportable_get_surface", libchamp.}
proc newFileCache*(size_limit: cuint; cache_dir: cstring; renderer: Renderer): FileCache {.importc:"champlain_file_cache_new_full", libchamp.}
proc getSizeLimit*(file_cache: FileCache): cuint {.importc:"champlain_file_cache_get_size_limit", libchamp.}
proc setSizeLimit*(file_cache: FileCache; size_limit: cuint) {.importc:"champlain_file_cache_set_size_limit", libchamp.}
proc getCacheDir*(file_cache: FileCache): cstring {.importc:"champlain_file_cache_get_cache_dir", libchamp.}
proc purge*(file_cache: FileCache) {.importc:"champlain_file_cache_purge", libchamp.}
proc purgeOnIdle*(file_cache: FileCache) {.importc:"champlain_file_cache_purge_on_idle", libchamp.}
proc newFileTileSource*(id: cstring; name: cstring; license: cstring; license_uri: cstring; min_zoom: cuint; max_zoom: cuint; tile_size: cuint; projection: MapProjection; renderer: Renderer): FileTileSource {.importc:"champlain_file_tile_source_new_full", libchamp.}
proc loadMapData*(self: FileTileSource; map_path: cstring) {.importc:"champlain_file_tile_source_load_map_data", libchamp.}
proc newImageRenderer*(): ImageRenderer {.importc:"champlain_image_renderer_new", libchamp.}
proc newKineticScrollView*(kinetic: Gboolean; viewport: Viewport): Actor {.importc:"champlain_kinetic_scroll_view_new", libchamp.}
proc stop*(self: KineticScrollView) {.importc:"champlain_kinetic_scroll_view_stop", libchamp.}
proc newLabel*(): Actor {.importc:"champlain_label_new", libchamp.}
proc newLabel*(text: cstring; font: cstring; text_color: clutter.Color; label_color: clutter.Color): Actor {.importc:"champlain_label_new_with_text", libchamp.}
proc newLabel*(actor: Actor): Actor {.importc:"champlain_label_new_with_image", libchamp.}
proc newLabel*(filename: cstring; error: ptr ptr GError): Actor {.importc:"champlain_label_new_from_file", libchamp.}
proc newLabel*(text: cstring; actor: Actor): Actor {.importc:"champlain_label_new_full", libchamp.}
proc setText*(label: Label; text: cstring) {.importc:"champlain_label_set_image", libchamp.}
proc setImage*(label: Label; image: Actor) {.importc:"champlain_label_set_image", libchamp.}
proc setUseMarkup*(label: Label; use_markup: Gboolean) {.importc:"champlain_label_set_use_markup", libchamp.}
proc setAlignment*(label: Label; alignment: pango.Alignment) {.importc:"champlain_label_set_alignment", libchamp.}
proc setColor*(label: Label; color: clutter.Color) {.importc:"champlain_label_set_color", libchamp.}
proc setTextColor*(label: Label; color: clutter.Color) {.importc:"champlain_label_set_text_color", libchamp.}
proc setFontName*(label: Label; font_name: cstring) {.importc:"champlain_label_set_font_name", libchamp.}
proc setWrap*(label: Label; wrap: Gboolean) {.importc:"champlain_label_set_wrap", libchamp.}
proc setWrapMode*(label: Label; wrap_mode: pango.WrapMode) {.importc:"champlain_label_set_wrap_mode", libchamp.}
proc setAttributes*(label: Label; list: AttrList) {.importc:"champlain_label_set_attributes", libchamp.}
proc setSingleLineMode*(label: Label; mode: Gboolean) {.importc:"champlain_label_set_single_line_mode", libchamp.}
proc setEllipsize*(label: Label; mode: EllipsizeMode) {.importc:"champlain_label_set_ellipsize", libchamp.}
proc setDrawBackground*(label: Label; background: Gboolean) {.importc:"champlain_label_set_draw_background", libchamp.}
proc setDrawShadow*(label: Label; shadow: Gboolean) {.importc:"champlain_label_set_draw_shadow", libchamp.}
proc getUseMarkup*(label: Label): Gboolean {.importc:"champlain_label_get_use_markup", libchamp.}
proc getText*(label: Label): cstring {.importc:"champlain_label_get_text", libchamp.}
proc getImage*(label: Label): Actor {.importc:"champlain_label_get_image", libchamp.}
proc getAlignment*(label: Label): pango.Alignment {.importc:"champlain_label_get_alignment", libchamp.}
proc getColor*(label: Label): clutter.Color {.importc:"champlain_label_get_color", libchamp.}
proc getTextColor*(label: Label): clutter.Color {.importc:"champlain_label_get_text_color", libchamp.}
proc getFontName*(label: Label): cstring {.importc:"champlain_label_get_font_name", libchamp.}
proc getWrap*(label: Label): Gboolean {.importc:"champlain_label_get_wrap", libchamp.}
proc getWrapMode*(label: Label): pango.WrapMode {.importc:"champlain_label_get_wrap_mode", libchamp.}
proc getEllipsize*(label: Label): EllipsizeMode {.importc:"champlain_label_get_ellipsize", libchamp.}
proc getSingleLineMode*(label: Label): Gboolean {.importc:"champlain_label_get_single_line_mode", libchamp.}
proc getDrawBackground*(label: Label): Gboolean {.importc:"champlain_label_get_draw_background", libchamp.}
proc getDrawShadow*(label: Label): Gboolean {.importc:"champlain_label_get_draw_shadow", libchamp.}
proc getAttributes*(label: Label): AttrList {.importc:"champlain_label_get_attributes", libchamp.}
proc setView*(layer: Label; view: View) {.importc:"champlain_layer_set_view", libchamp.}
proc getBoundingBox*(layer: Label): BoundingBox {.importc:"champlain_layer_get_bounding_box", libchamp.}
proc newLicense*(): Actor {.importc:"champlain_license_new", libchamp.}
proc setExtraText*(license: License; text: cstring) {.importc:"champlain_license_set_extra_text", libchamp.}
proc getExtraText*(license: License): cstring {.importc:"champlain_license_get_extra_text", libchamp.}
proc setAlignment*(license: License; alignment: pango.Alignment) {.importc:"champlain_license_set_alignment", libchamp.}
proc getAlignment*(license: License): pango.Alignment {.importc:"champlain_license_get_alignment", libchamp.}
proc connectView*(license: License; view: View) {.importc:"champlain_license_connect_view", libchamp.}
proc disconnectView*(license: License) {.importc:"champlain_license_disconnect_view", libchamp.}
proc setLocation*(location: Location; latitude: cdouble; longitude: cdouble) {.importc:"champlain_location_set_location", libchamp.}
proc getLatitude*(location: Location): cdouble {.importc:"champlain_location_get_latitude", libchamp.}
proc getLongitude*(location: Location): cdouble {.importc:"champlain_location_get_longitude", libchamp.}
proc newMapSourceChain*(): MapSourceChain {.importc:"champlain_map_source_chain_new", libchamp.}
proc push*(source_chain: MapSourceChain; map_source: MapSource) {.importc:"champlain_map_source_chain_push", libchamp.}
proc pop*(source_chain: MapSourceChain) {.importc:"champlain_map_source_chain_pop", libchamp.}
proc newMapSourceDesc*(id: cstring; name: cstring; license: cstring; license_uri: cstring; min_zoom: cuint; max_zoom: cuint; tile_size: cuint; projection: MapProjection; uri_format: cstring; constructor: MapSourceConstructor; data: Gpointer): MapSourceDesc {.importc:"champlain_map_source_desc_new_full", libchamp.}
proc getId*(desc: MapSourceDesc): cstring {.importc:"champlain_map_source_desc_get_id", libchamp.}
proc getName*(desc: MapSourceDesc): cstring {.importc:"champlain_map_source_desc_get_name", libchamp.}
proc getLicense*(desc: MapSourceDesc): cstring {.importc:"champlain_map_source_desc_get_license", libchamp.}
proc getLicenseUri*(desc: MapSourceDesc): cstring {.importc:"champlain_map_source_desc_get_license_uri", libchamp.}
proc getUriFormat*(desc: MapSourceDesc): cstring {.importc:"champlain_map_source_desc_get_uri_format", libchamp.}
proc getMinZoomLevel*(desc: MapSourceDesc): cuint {.importc:"champlain_map_source_desc_get_min_zoom_level", libchamp.}
proc getMaxZoomLevel*(desc: MapSourceDesc): cuint {.importc:"champlain_map_source_desc_get_max_zoom_level", libchamp.}
proc getTileSize*(desc: MapSourceDesc): cuint {.importc:"champlain_map_source_desc_get_tile_size", libchamp.}
proc getProjection*(desc: MapSourceDesc): MapProjection {.importc:"champlain_map_source_desc_get_projection", libchamp.}
proc getData*(desc: MapSourceDesc): Gpointer {.importc:"champlain_map_source_desc_get_data", libchamp.}
proc getConstructor*(desc: MapSourceDesc): MapSourceConstructor {.importc:"champlain_map_source_desc_get_constructor", libchamp.}
proc dupDefault*(): MapSourceFactory {.importc:"champlain_map_source_factory_dup_default", libchamp.}
proc createSource*(factory: MapSourceFactory; id: cstring): MapSource {.importc:"champlain_map_source_factory_create", libchamp.}
proc createCachedSource*(factory: MapSourceFactory; id: cstring): MapSource {.importc:"champlain_map_source_factory_create_cached_source", libchamp.}
proc createMemcachedSource*(factory: MapSourceFactory; id: cstring): MapSource {.importc:"champlain_map_source_factory_create_memcached_source", libchamp.}
proc createErrorSource*(factory: MapSourceFactory; tile_size: cuint): MapSource {.importc:"champlain_map_source_factory_create_error_source", libchamp.}
proc register*(factory: MapSourceFactory; desc: MapSourceDesc): Gboolean {.importc:"champlain_map_source_factory_register", libchamp.}
proc getRegistered*(factory: MapSourceFactory): ptr GSList {.importc:"champlain_map_source_factory_get_registered", libchamp.}
proc getNextSource*(map_source: MapSource): MapSource {.importc:"champlain_map_source_get_next_source", libchamp.}
proc setNextSource*(map_source: MapSource; next_source: MapSource) {.importc:"champlain_map_source_set_next_source", libchamp.}
proc getRenderer*(map_source: MapSource): Renderer {.importc:"", libchamp.}
proc setRenderer*(map_source: MapSource; renderer: Renderer) {.importc:"champlain_map_source_get_renderer", libchamp.}
proc getId*(map_source: MapSource): cstring {.importc:"champlain_map_source_get_id", libchamp.}
proc getName*(map_source: MapSource): cstring {.importc:"champlain_map_source_get_name", libchamp.}
proc getLicense*(map_source: MapSource): cstring {.importc:"champlain_map_source_get_license_uri", libchamp.}
proc getLicenseUri*(map_source: MapSource): cstring {.importc:"champlain_map_source_get_license_uri", libchamp.}
proc getMinZoomLevel*(map_source: MapSource): cuint {.importc:"champlain_map_source_get_min_zoom_level", libchamp.}
proc getMaxZoomLevel*(map_source: MapSource): cuint {.importc:"champlain_map_source_get_max_zoom_level", libchamp.}
proc getTileSize*(map_source: MapSource): cuint {.importc:"champlain_map_source_get_tile_size", libchamp.}
proc getProjection*(map_source: MapSource): MapProjection {.importc:"champlain_map_source_get_projection", libchamp.}
proc getX*(map_source: MapSource; zoom_level: cuint; longitude: cdouble): cdouble {.importc:"champlain_map_source_get_x", libchamp.}
proc getY*(map_source: MapSource; zoom_level: cuint; latitude: cdouble): cdouble {.importc:"champlain_map_source_get_y", libchamp.}
proc getLongitude*(map_source: MapSource; zoom_level: cuint; x: cdouble): cdouble {.importc:"champlain_map_source_get_longitude", libchamp.}
proc getLatitude*(map_source: MapSource; zoom_level: cuint; y: cdouble): cdouble {.importc:"champlain_map_source_get_latitude", libchamp.}
proc getRowCount*(map_source: MapSource; zoom_level: cuint): cuint {.importc:"champlain_map_source_get_row_count", libchamp.}
proc getColumnCount*(map_source: MapSource; zoom_level: cuint): cuint {.importc:"champlain_map_source_get_column_count", libchamp.}
proc getMetersPerPixel*(map_source: MapSource; zoom_level: cuint; latitude: cdouble; longitude: cdouble): cdouble {.importc:"champlain_map_source_get_meters_per_pixel", libchamp.}
proc fillTile*(map_source: MapSource; tile: Tile) {.importc:"champlain_map_source_fill_tile", libchamp.}
proc newMarkerLayer*(): MarkerLayer {.importc:"champlain_marker_layer_new", libchamp.}
proc newMarkerLayer*(mode: SelectionMode): MarkerLayer {.importc:"champlain_marker_layer_new_full", libchamp.}
proc addMarker*(layer: MarkerLayer; marker: Marker) {.importc:"champlain_marker_layer_add_marker", libchamp.}
proc removeMarker*(layer: MarkerLayer; marker: Marker) {.importc:"champlain_marker_layer_remove_marker", libchamp.}
proc removeAll*(layer: MarkerLayer) {.importc:"champlain_marker_layer_remove_all", libchamp.}
proc getMarkers*(layer: MarkerLayer): ptr GList {.importc:"champlain_marker_layer_get_markers", libchamp.}
proc getSelected*(layer: MarkerLayer): ptr GList {.importc:"champlain_marker_layer_get_selected", libchamp.}
proc animateInAllMarkers*(layer: MarkerLayer) {.importc:"champlain_marker_layer_animate_in_all_markers", libchamp.}
proc animateOutAllMarkers*(layer: MarkerLayer) {.importc:"champlain_marker_layer_animate_out_all_markers", libchamp.}
proc showAllMarkers*(layer: MarkerLayer) {.importc:"champlain_marker_layer_show_all_markers", libchamp.}
proc hideAllMarkers*(layer: MarkerLayer) {.importc:"champlain_marker_layer_hide_all_markers", libchamp.}
proc setAllMarkersDraggable*(layer: MarkerLayer) {.importc:"champlain_marker_layer_set_all_markers_draggable", libchamp.}
proc setAllMarkersUndraggable*(layer: MarkerLayer) {.importc:"champlain_marker_layer_set_all_markers_undraggable", libchamp.}
proc selectAllMarkers*(layer: MarkerLayer) {.importc:"champlain_marker_layer_select_all_markers", libchamp.}
proc unselectAllMarkers*(layer: MarkerLayer) {.importc:"champlain_marker_layer_unselect_all_markers", libchamp.}
proc setSelectionMode*(layer: MarkerLayer; mode: SelectionMode) {.importc:"champlain_marker_layer_set_selection_mode", libchamp.}
proc getSelectionMode*(layer: MarkerLayer): SelectionMode {.importc:"champlain_marker_layer_get_selection_mode", libchamp.}
proc newMarker*(): Actor  {.importc:"champlain_marker_new", libchamp.}
proc setSelectable*(marker: Marker; value: Gboolean) {.importc:"champlain_marker_set_selectable", libchamp.}
proc getSelectable*(marker: Marker): Gboolean {.importc:"champlain_marker_get_selectable", libchamp.}
proc setDraggable*(marker: Marker; value: Gboolean) {.importc:"champlain_marker_set_draggable", libchamp.}
proc getDraggable*(marker: Marker): Gboolean {.importc:"champlain_marker_get_draggable", libchamp.}
proc setSelected*(marker: Marker; value: Gboolean) {.importc:"champlain_marker_set_selected", libchamp.}
proc getSelected*(marker: Marker): Gboolean {.importc:"champlain_marker_get_selected", libchamp.}
proc animateIn*(marker: Marker) {.importc:"champlain_marker_animate_in", libchamp.}
proc animateInWithDelay*(marker: Marker; delay: cuint) {.importc:"champlain_marker_animate_in_with_delay", libchamp.}
proc animateOut*(marker: Marker) {.importc:"champlain_marker_animate_out", libchamp.}
proc animateOutWithDelay*(marker: Marker; delay: cuint) {.importc:"champlain_marker_animate_out_with_delay", libchamp.}
proc setSelectionColor*(color: clutter.Color) {.importc:"champlain_marker_set_selection_color", libchamp.}
proc getSelectionColor*(): clutter.Color {.importc:"champlain_marker_get_selection_color", libchamp.}
proc setSelectionTextColor*(color: clutter.Color) {.importc:"champlain_marker_set_selection_text_color", libchamp.}
proc getSelectionTextColor*(): clutter.Color {.importc:"champlain_marker_get_selection_text_color", libchamp.}
proc marshal_VOID_DOUBLE_DOUBLE_BOXED*(closure: ptr GClosure; return_value: ptr GValue; n_param_values: cuint; param_values: ptr GValue; invocation_hint: Gpointer; marshal_data: Gpointer) {.importc:"champlain_marshal_VOID__DOUBLE_DOUBLE_BOXED", libchamp.}
proc marshal_VOID_POINTER_UINT_BOOLEAN*(closure: ptr GClosure; return_value: ptr GValue; n_param_values: cuint; param_values: ptr GValue; invocation_hint: Gpointer; marshal_data: Gpointer) {.importc:"champlain_marshal_VOID__POINTER_UINT_BOOLEAN", libchamp.}
proc marshal_VOID_UINT_UINT*(closure: ptr GClosure; return_value: ptr GValue; n_param_values: cuint; param_values: ptr GValue; invocation_hint: Gpointer; marshal_data: Gpointer) {.importc:"champlain_marshal_VOID__UINT_UINT", libchamp.}
proc marshal_VOID_OBJECT_OBJECT*(closure: ptr GClosure; return_value: ptr GValue; n_param_values: cuint; param_values: ptr GValue; invocation_hint: Gpointer; marshal_data: Gpointer) {.importc:"champlain_marshal_VOID__OBJECT_OBJECT", libchamp.}
proc newMemoryCache*(size_limit: cuint; renderer: Renderer): MemoryCache {.importc:"champlain_memory_cache_new_full", libchamp.}
proc getSizeLimit*(memory_cache: MemoryCache): cuint {.importc:"champlain_memory_cache_get_size_limit", libchamp.}
proc setSizeLimit*(memory_cache: MemoryCache; size_limit: cuint) {.importc:"champlain_memory_cache_set_size_limit", libchamp.}
proc clean*(memory_cache: MemoryCache) {.importc:"champlain_memory_cache_clean", libchamp.}
proc newMemphisRenderer*(tile_size: cuint): MemphisRenderer {.importc:"champlain_memphis_renderer_new_full", libchamp.}
proc loadRules*(renderer: MemphisRenderer; rules_path: cstring) {.importc:"champlain_memphis_renderer_load_rules", libchamp.}
proc getBackgroundColor*(renderer: MemphisRenderer): clutter.Color {.importc:"champlain_memphis_renderer_get_background_color", libchamp.}
proc setBackgroundColor*(renderer: MemphisRenderer; color: clutter.Color) {.importc:"champlain_memphis_renderer_set_background_color", libchamp.}
proc getRuleIds*(renderer: MemphisRenderer): ptr GList {.importc:"champlain_memphis_renderer_get_rule_ids", libchamp.}
proc setRule*(renderer: MemphisRenderer; rule: ptr MemphisRuleObj) {.importc:"champlain_memphis_renderer_set_rule", libchamp.}
proc getRule*(renderer: MemphisRenderer; id: cstring): ptr MemphisRuleObj {.importc:"champlain_memphis_renderer_get_rule", libchamp.}
proc removeRule*(renderer: MemphisRenderer; id: cstring) {.importc:"champlain_memphis_renderer_remove_rule", libchamp.}
proc getBoundingBox*(renderer: MemphisRenderer): BoundingBox {.importc:"champlain_memphis_renderer_get_bounding_box", libchamp.}
proc setTileSize*(renderer: MemphisRenderer; size: cuint) {.importc:"champlain_memphis_renderer_set_tile_size", libchamp.}
proc getTileSize*(renderer: MemphisRenderer): cuint {.importc:"champlain_memphis_renderer_get_tile_size", libchamp.}
proc newNetworkBboxTileSource*(id: cstring; name: cstring; license: cstring; license_uri: cstring; min_zoom: cuint; max_zoom: cuint; tile_size: cuint; projection: MapProjection; renderer: Renderer): NetworkBboxTileSource {.importc:"champlain_network_bbox_tile_source_new_full", libchamp.}
proc loadMapData*(map_data_source: NetworkBboxTileSource; bbox: BoundingBox) {.importc:"champlain_network_bbox_tile_source_load_map_data", libchamp.}
proc getApiUri*(map_data_source: NetworkBboxTileSource): cstring {.importc:"champlain_network_bbox_tile_source_get_api_uri", libchamp.}
proc setApiUri*(map_data_source: NetworkBboxTileSource; api_uri: cstring) {.importc:"champlain_network_bbox_tile_source_set_api_uri", libchamp.}
proc setUserAgent*(map_data_source: NetworkBboxTileSource; user_agent: cstring) {.importc:"champlain_network_bbox_tile_source_set_user_agent", libchamp.}
proc newNetworkTileSource*(id: cstring; name: cstring; license: cstring; license_uri: cstring; min_zoom: cuint; max_zoom: cuint; tile_size: cuint; projection: MapProjection; uri_format: cstring; renderer: Renderer): NetworkTileSource {.importc:"champlain_network_tile_source_new_full", libchamp.}
proc getUriFormat*(tile_source: NetworkTileSource): cstring {.importc:"champlain_network_tile_source_get_uri_format", libchamp.}
proc setUriFormat*(tile_source: NetworkTileSource; uri_format: cstring) {.importc:"champlain_network_tile_source_set_uri_format", libchamp.}
proc getOffline*(tile_source: NetworkTileSource): Gboolean {.importc:"champlain_network_tile_source_get_offline", libchamp.}
proc setOffline*(tile_source: NetworkTileSource; offline: Gboolean) {.importc:"champlain_network_tile_source_set_offline", libchamp.}
proc getProxyUri*(tile_source: NetworkTileSource): cstring {.importc:"champlain_network_tile_source_get_proxy_uri", libchamp.}
proc setProxyUri*(tile_source: NetworkTileSource; proxy_uri: cstring) {.importc:"champlain_network_tile_source_set_proxy_uri", libchamp.}
proc getMaxConns*(tile_source: NetworkTileSource): cint {.importc:"champlain_network_tile_source_get_max_conns", libchamp.}
proc setMaxConns*(tile_source: NetworkTileSource; max_conns: cint) {.importc:"champlain_network_tile_source_set_max_conns", libchamp.}
proc setUserAgent*(tile_source: NetworkTileSource; user_agent: cstring) {.importc:"champlain_network_tile_source_set_user_agent", libchamp.}
proc newNullTileSource*(renderer: Renderer): NullTileSource {.importc:"champlain_null_tile_source_new_full", libchamp.}
proc newPathLayer*(): PathLayer {.importc:"champlain_path_layer_new", libchamp.}
proc addNode*(layer: PathLayer; location: Location) {.importc:"champlain_path_layer_add_node", libchamp.}
proc removeNode*(layer: PathLayer; location: Location) {.importc:"champlain_path_layer_remove_node", libchamp.}
proc removeAll*(layer: PathLayer) {.importc:"champlain_path_layer_remove_all", libchamp.}
proc insertNode*(layer: PathLayer; location: Location; position: cuint) {.importc:"champlain_path_layer_insert_node", libchamp.}
proc getNodes*(layer: PathLayer): ptr GList {.importc:"champlain_path_layer_get_nodes", libchamp.}
proc getFillColor*(layer: PathLayer): clutter.Color {.importc:"champlain_path_layer_get_fill_color", libchamp.}
proc setFillColor*(layer: PathLayer; color: clutter.Color) {.importc:"champlain_path_layer_set_fill_color", libchamp.}
proc getStrokeColor*(layer: PathLayer): clutter.Color {.importc:"champlain_path_layer_get_stroke_color", libchamp.}
proc setStrokeColor*(layer: PathLayer; color: clutter.Color) {.importc:"champlain_path_layer_set_stroke_color", libchamp.}
proc getFill*(layer: PathLayer): Gboolean {.importc:"champlain_path_layer_get_fill", libchamp.}
proc setFill*(layer: PathLayer; value: Gboolean) {.importc:"champlain_path_layer_set_fill", libchamp.}
proc getStroke*(layer: PathLayer): Gboolean {.importc:"champlain_path_layer_get_stroke", libchamp.}
proc setStroke*(layer: PathLayer; value: Gboolean) {.importc:"champlain_path_layer_set_stroke", libchamp.}
proc getStrokeWidth*(layer: PathLayer): cdouble {.importc:"champlain_path_layer_get_stroke_width", libchamp.}
proc setStrokeWidth*(layer: PathLayer; value: cdouble) {.importc:"champlain_path_layer_set_stroke_width", libchamp.}
proc getVisible*(layer: PathLayer): Gboolean  {.importc:"champlain_path_layer_get_visible", libchamp.}
proc setVisible*(layer: PathLayer; value: Gboolean) {.importc:"champlain_path_layer_set_visible", libchamp.}
proc getClosed*(layer: PathLayer): Gboolean {.importc:"champlain_path_layer_get_closed", libchamp.}
proc setClosed*(layer: PathLayer; value: Gboolean) {.importc:"champlain_path_layer_set_closed", libchamp.}
proc getDash*(layer: PathLayer): ptr GList {.importc:"champlain_path_layer_get_dash", libchamp.}
proc setDash*(layer: PathLayer; dash_pattern: ptr GList) {.importc:"champlain_path_layer_set_dash", libchamp.}
proc newPoint*(): Actor {.importc:"champlain_point_new", libchamp.}
proc newPoint*(size: cdouble; color: clutter.Color): Actor {.importc:"champlain_point_new_full", libchamp.}
proc setColor*(point: Point; color: clutter.Color) {.importc:"champlain_point_set_color", libchamp.}
proc getColor*(point: Point): clutter.Color {.importc:"champlain_point_get_color", libchamp.}
proc setSize*(point: Point; size: cdouble) {.importc:"champlain_point_get_color", libchamp.}
proc getSize*(point: Point): cdouble {.importc:"champlain_point_get_size", libchamp.}
proc setData*(renderer: Renderer; data: cstring; size: cuint) {.importc:"champlain_renderer_set_data", libchamp.}
proc render*(renderer: Renderer; tile: Tile) {.importc:"champlain_renderer_render", libchamp.}
proc newScale*(): Actor {.importc:"champlain_scale_new", libchamp.}
proc setMaxWidth*(scale: Scale; value: cuint) {.importc:"champlain_scale_set_max_width", libchamp.}
proc setUnit*(scale: Scale; unit: Unit) {.importc:"champlain_scale_set_unit", libchamp.}
proc getMaxWidth*(scale: Scale): cuint {.importc:"champlain_scale_get_max_width", libchamp.}
proc getUnit*(scale: Scale): Unit {.importc:"champlain_scale_get_unit", libchamp.}
proc connectView*(scale: Scale; view: View) {.importc:"champlain_scale_connect_view", libchamp.}
proc disconnectView*(scale: Scale) {.importc:"champlain_scale_disconnect_view", libchamp.}
proc cacheStoreTile*(tile_cache: TileCache; tile: Tile; contents: cstring; size: Gsize) {.importc:"champlain_tile_cache_store_tile", libchamp.}
proc cacheRefreshTileTime*(tile_cache: TileCache; tile: Tile) {.importc:"champlain_tile_cache_refresh_tile_time", libchamp.}
proc cacheOnTileFilled*(tile_cache: TileCache; tile: Tile) {.importc:"champlain_tile_cache_on_tile_filled", libchamp.}
proc getCache*(tile_source: TileSource): TileCache {.importc:"champlain_tile_source_get_cache", libchamp.}
proc setCache*(tile_source: TileSource; cache: TileCache) {.importc:"champlain_tile_source_set_cache", libchamp.}
proc setId*(tile_source: TileSource; id: cstring) {.importc:"champlain_tile_source_set_id", libchamp.}
proc setName*(tile_source: TileSource; name: cstring) {.importc:"champlain_tile_source_set_name", libchamp.}
proc setLicense*(tile_source: TileSource; license: cstring) {.importc:"champlain_tile_source_set_license", libchamp.}
proc setLicenseUri*(tile_source: TileSource; license_uri: cstring) {.importc:"champlain_tile_source_set_license_uri", libchamp.}
proc setMinZoomLevel*(tile_source: TileSource; zoom_level: cuint) {.importc:"champlain_tile_source_set_min_zoom_level", libchamp.}
proc setMaxZoomLevel*(tile_source: TileSource; zoom_level: cuint) {.importc:"champlain_tile_source_set_max_zoom_level", libchamp.}
proc setTileSize*(tile_source: TileSource; tile_size: cuint) {.importc:"champlain_tile_source_set_tile_size", libchamp.}
proc setProjection*(tile_source: TileSource; projection: MapProjection) {.importc:"champlain_tile_source_set_projection", libchamp.}
proc newTile*(): Tile {.importc:"champlain_tile_new", libchamp.}
proc newTile*(x: cuint; y: cuint; size: cuint; zoom_level: cuint): Tile {.importc:"champlain_tile_new_full", libchamp.}
proc getX*(self: Tile): cuint {.importc:"champlain_tile_get_x", libchamp.}
proc getY*(self: Tile): cuint {.importc:"champlain_tile_get_y", libchamp.}
proc getZoomLevel*(self: Tile): cuint {.importc:"champlain_tile_get_zoom_level", libchamp.}
proc getSize*(self: Tile): cuint {.importc:"champlain_tile_get_size", libchamp.}
proc getState*(self: Tile): State {.importc:"champlain_tile_get_state", libchamp.}
proc getContent*(self: Tile): Actor {.importc:"champlain_tile_get_content", libchamp.}
proc getModifiedTime*(self: Tile): ptr GTimeVal {.importc:"champlain_tile_get_modified_time", libchamp.}
proc getEtag*(self: Tile): cstring {.importc:"champlain_tile_get_etag", libchamp.}
proc getFadeIn*(self: Tile): Gboolean {.importc:"champlain_tile_get_fade_in", libchamp.}
proc setX*(self: Tile; x: cuint) {.importc:"champlain_tile_set_x", libchamp.}
proc setY*(self: Tile; y: cuint) {.importc:"champlain_tile_set_y", libchamp.}
proc setZoomLevel*(self: Tile; zoom_level: cuint) {.importc:"champlain_tile_set_zoom_level", libchamp.}
proc setSize*(self: Tile; size: cuint) {.importc:"champlain_tile_set_size", libchamp.}
proc setState*(self: Tile; state: State) {.importc:"champlain_tile_set_state", libchamp.}
proc setContent*(self: Tile; actor: Actor) {.importc:"champlain_tile_set_content", libchamp.}
proc setEtag*(self: Tile; etag: cstring) {.importc:"champlain_tile_set_etag", libchamp.}
proc setModifiedTime*(self: Tile; time: ptr GTimeVal) {.importc:"champlain_tile_set_modified_time", libchamp.}
proc setFadeIn*(self: Tile; fade_in: Gboolean) {.importc:"champlain_tile_set_fade_in", libchamp.}
proc displayContent*(self: Tile) {.importc:"champlain_tile_display_content", libchamp.}
proc newView*(): Actor {.importc:"champlain_view_new", libchamp.}
proc centerOn*(view: View; latitude: cdouble; longitude: cdouble) {.importc:"champlain_view_center_on", libchamp.}
proc goTo*(view: View; latitude: cdouble; longitude: cdouble) {.importc:"champlain_view_go_to", libchamp.}
proc stopGoTo*(view: View) {.importc:"champlain_view_stop_go_to", libchamp.}
proc getCenterLatitude*(view: View): cdouble {.importc:"champlain_view_get_center_latitude", libchamp.}
proc getCenterLongitude*(view: View): cdouble {.importc:"champlain_view_get_center_longitude", libchamp.}
proc zoomIn*(view: View) {.importc:"champlain_view_zoom_in", libchamp.}
proc zoomOut*(view: View) {.importc:"champlain_view_zoom_out", libchamp.}
proc setZoomLevel*(view: View; zoom_level: cuint) {.importc:"champlain_view_set_zoom_level", libchamp.}
proc setMinZoomLevel*(view: View; zoom_level: cuint) {.importc:"champlain_view_set_min_zoom_level", libchamp.}
proc setMaxZoomLevel*(view: View; zoom_level: cuint) {.importc:"champlain_view_set_max_zoom_level", libchamp.}
proc ensureVisible*(view: View; bbox: BoundingBox; animate: Gboolean) {.importc:"champlain_view_ensure_visible", libchamp.}
proc ensureLayersVisible*(view: View; animate: Gboolean) {.importc:"champlain_view_ensure_layers_visible", libchamp.}
proc setMapSource*(view: View; map_source: MapSource) {.importc:"champlain_view_set_map_source", libchamp.}
proc addOverlaySource*(view: View; map_source: MapSource; opacity: cuchar) {.importc:"champlain_view_add_overlay_source", libchamp.}
proc removeOverlaySource*(view: View; map_source: MapSource) {.importc:"champlain_view_remove_overlay_source", libchamp.}
proc getOverlaySources*(view: View): ptr GList {.importc:"champlain_view_get_overlay_sources", libchamp.}
proc setDeceleration*(view: View; rate: cdouble) {.importc:"champlain_view_set_deceleration", libchamp.}
proc setKineticMode*(view: View; kinetic: Gboolean) {.importc:"champlain_view_set_kinetic_mode", libchamp.}
proc setKeepCenterOnResize*(view: View; value: Gboolean) {.importc:"champlain_view_set_keep_center_on_resize", libchamp.}
proc setZoomOnDoubleClick*(view: View; value: Gboolean) {.importc:"champlain_view_set_zoom_on_double_click", libchamp.}
proc setAnimateZoom*(view: View; value: Gboolean) {.importc:"champlain_view_set_animate_zoom", libchamp.}
proc setBackgroundPattern*(view: View; background: clutter.Content) {.importc:"champlain_view_set_background_pattern", libchamp.}
proc setWorld*(view: View; bbox: BoundingBox) {.importc:"champlain_view_set_world", libchamp.}
proc setHorizontalWrap*(view: View; wrap: Gboolean) {.importc:"champlain_view_set_horizontal_wrap", libchamp.}
proc addLayer*(view: View; layer: Label) {.importc:"champlain_view_add_layer", libchamp.}
proc removeLayer*(view: View; layer: Label) {.importc:"champlain_view_remove_layer", libchamp.}
proc toSurface*(view: View; include_layers: Gboolean): Surface {.importc:"champlain_view_to_surface", libchamp.}
proc getZoomLevel*(view: View): cuint {.importc:"champlain_view_get_zoom_level", libchamp.}
proc getMinZoomLevel*(view: View): cuint {.importc:"champlain_view_get_min_zoom_level", libchamp.}
proc getMaxZoomLevel*(view: View): cuint {.importc:"champlain_view_get_max_zoom_level", libchamp.}
proc getMapSource*(view: View): MapSource {.importc:"champlain_view_get_map_source", libchamp.}
proc getDeceleration*(view: View): cdouble {.importc:"champlain_view_get_deceleration", libchamp.}
proc getKineticMode*(view: View): Gboolean {.importc:"champlain_view_get_kinetic_mode", libchamp.}
proc getKeepCenterOnResize*(view: View): Gboolean {.importc:"champlain_view_get_keep_center_on_resize", libchamp.}
proc getZoomOnDoubleClick*(view: View): Gboolean {.importc:"champlain_view_get_zoom_on_double_click", libchamp.}
proc getAnimateZoom*(view: View): Gboolean {.importc:"champlain_view_get_animate_zoom", libchamp.}
proc getState*(view: View): State {.importc:"champlain_view_get_state", libchamp.}
proc getBackgroundPattern*(view: View): clutter.Content {.importc:"champlain_view_get_background_pattern", libchamp.}
proc getWorld*(view: View): BoundingBox {.importc:"champlain_view_get_world", libchamp.}
proc getHorizontalWrap*(view: View): Gboolean {.importc:"champlain_view_get_horizontal_wrap", libchamp.}
proc reloadTiles*(view: View) {.importc:"champlain_view_reload_tiles", libchamp.}
proc xToLongitude*(view: View; x: cdouble): cdouble {.importc:"champlain_view_x_to_longitude", libchamp.}
proc yToLatitude*(view: View; y: cdouble): cdouble {.importc:"champlain_view_y_to_latitude", libchamp.}
proc longitudeToX*(view: View; longitude: cdouble): cdouble {.importc:"champlain_view_longitude_to_x", libchamp.}
proc latitudeToY*(view: View; latitude: cdouble): cdouble {.importc:"champlain_view_latitude_to_y", libchamp.}
proc getViewportAnchor*(view: View; anchor_x: ptr cint; anchor_y: ptr cint) {.importc:"champlain_view_get_viewport_anchor", libchamp.}
proc getViewportOrigin*(view: View; x: ptr cint; y: ptr cint) {.importc:"champlain_view_get_viewport_origin", libchamp.}
when not defined(GTK_DISABLE_DEPRECATED):
  proc binLayoutAdd*(view: View; child: Actor; x_align: BinAlignment; y_align: BinAlignment) {.importc:"champlain_view_bin_layout_add", libchamp.}
proc getLicenseActor*(view: View): License {.importc:"champlain_view_get_license_actor", libchamp.}
proc getBoundingBox*(view: View): BoundingBox {.importc:"champlain_view_get_bounding_box", libchamp.}
proc getBoundingBoxForZoomLevel*(view: View; zoom_level: cuint): BoundingBox {.importc:"champlain_view_get_bounding_box_for_zoom_level", libchamp.}
proc newViewport*(): Actor {.importc:"champlain_viewport_new", libchamp.}
proc setOrigin*(viewport: Viewport; x: cdouble; y: cdouble) {.importc:"champlain_viewport_set_origin", libchamp.}
proc getOrigin*(viewport: Viewport; x: ptr cdouble; y: ptr cdouble) {.importc:"champlain_viewport_get_origin", libchamp.}
proc stop*(viewport: Viewport) {.importc:"champlain_viewport_stop", libchamp.}
proc getAdjustments*(viewport: Viewport; hadjustment: ptr Adjustment; vadjustment: ptr Adjustment) {.importc:"champlain_viewport_get_adjustments", libchamp.}
proc setAdjustments*(viewport: Viewport; hadjustment: Adjustment; vadjustment: Adjustment) {.importc:"champlain_viewport_set_adjustments", libchamp.}
proc setChild*(viewport: Viewport; child: Actor) {.importc:"champlain_viewport_set_child", libchamp.}
proc getAnchor*(viewport: Viewport; x: ptr cint; y: ptr cint) {.importc:"champlain_viewport_get_anchor", libchamp.}
proc setActorPosition*(viewport: Viewport; actor: Actor; x: cdouble; y: cdouble) {.importc:"champlain_viewport_set_actor_position", libchamp.}
proc newGtkEmbed*(): Widget {.importc:"gtk_champlain_embed_new", libchampgtk.}
proc getView*(embed: GtkEmbed): View {.importc:"gtk_champlain_embed_get_view", libchampgtk.}