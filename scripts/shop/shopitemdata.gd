# scripts/shop/shop_item_data.gd
extends Resource
class_name ShopItemData

enum Currency { MONEY, SCIENCE }
enum Category { SATELLITE_UNLOCK, STATION_UNLOCK, RUN_WIDE_UPGRADE, INSTANCE_UPGRADE }

@export var item_id: String = ""
@export var item_name: String = ""
@export_multiline var description: String = ""
@export var cost: int = 0
@export var currency: Currency = Currency.MONEY
@export var category: Category = Category.SATELLITE_UNLOCK

# Only relevant when category is SATELLITE_UNLOCK / STATION_UNLOCK
@export var unlocks_satellite_type: SatelliteTypeData
@export var unlocks_station_type: StationTypeData

# Only relevant when category is RUN_WIDE_UPGRADE / INSTANCE_UPGRADE
@export var stat_name: String = ""
@export var stat_modifier: float = 0.0

# Tech tree gating - other items that must be owned first
@export var prerequisites: Array[ShopItemData] = []
