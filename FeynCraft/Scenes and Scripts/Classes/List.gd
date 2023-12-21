class_name List
extends PanelContainer

@export var Item: PackedScene
@export var ItemContainer: BoxContainer
@export var Title: Label

@export var title: String = '':
	set(new_value):
		title = new_value
		
		if Title:
			Title.text = title

@export var scroll_container: ScrollContainer

var items_data: Array

func _ready() -> void:
	scroll_container.get_v_scroll_bar().use_parent_material = true

func load_items(_items_data: Array) -> void:
	items_data = _items_data
	
	clear_items()
	
	for item_data in items_data:
		load_item(item_data)

func load_item(item_data = null, new_item: ListItem = Item.instantiate()) -> void:
	if item_data:
		new_item.load_data(item_data)

	new_item.index = ItemContainer.get_child_count() + 1
	new_item.deleted.connect(_item_deleted)
	ItemContainer.add_child(new_item)

func create_new_item() -> void:
	load_item()

func _item_deleted(item: ListItem) -> void:
	items_data.remove_at(get_items().find(item))
	item.queue_free()

func get_items() -> Array[ListItem]:
	var items: Array[ListItem] = []
	
	for item in ItemContainer.get_children():
		items.push_back(item)
	
	return items

func clear_items() -> void:
	for item in ItemContainer.get_children():
		item.queue_free()

func update_index_labels() -> void:
	for i in range(ItemContainer.get_child_count()):
		var item: ListItem = ItemContainer.get_child(i)
		
		if item.is_queued_for_deletion():
			continue
		
		item.index = i
