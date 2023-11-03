extends Node2D

class_name Snek

@export var sprite_sheet: Texture = load("res://assets/snake-sprites.png")
@export var sprite_sheet_size := Vector2i(6,0)

# Snake parts
var BODY_STRAIGHT := RSprite.new(Vector2i(0,0), "straight")
var BODY_CORNER := RSprite.new(Vector2i(2, 0), "corner")
var SNOUT := RSprite.new(Vector2i(3, 0), "snout")
var TAIL := RSprite.new(Vector2i(5, 0), "tail")
var BLELELE := RSprite.new(Vector2i(1,0), "blelele")

# locations of snake
var coords: Array[Vector2i]

var UP = Vector2i(0, -1)
var DOWN = Vector2i(0, 1)
var LEFT = Vector2i(-1, 0)
var RIGHT = Vector2i(1, 0)

func _ready() -> void:
	coords.append(Vector2i(2, 2))
	coords.append(Vector2i(3, 2))
	coords.append(Vector2i(3, 3))
	coords.append(Vector2i(3, 4))
	coords.append(Vector2i(4, 4))
	coords.append(Vector2i(4, 3))
	coords.append(Vector2i(4, 2))
	coords.append(Vector2i(5, 2))
	update_sprites()
	
func update_sprites() -> void:
	assert(coords.size() >= 3)
	spawn_sprites_if_necessary()
	assert(coords.size() == $Sprites.get_child_count())
	
	for i in range(0, coords.size()):
		var sprite = $Sprites.get_child(i) as Sprite2D
		var tile_position = coords[i]
		
		# set appropriate location
		sprite.position = tile_position * Globals.TILE_SIZE

		# set appropriate sprite
		if i == 0:
			sprite.frame_coords = SNOUT.coords
			var direction = coords[i] - coords[i + 1]
			sprite.rotation_degrees = get_head_rotation(direction)
			
			$Blelele.position = (tile_position + direction) * Globals.TILE_SIZE
			$Blelele.rotation_degrees = sprite.rotation_degrees
			
		elif i == coords.size() - 1:
			sprite.frame_coords = TAIL.coords
			sprite.rotation_degrees = get_tail_rotation(coords[i] - coords[i - 1])
			
		else:
			var prev = coords[i] - coords[i - 1]
			var next = coords[i] - coords[i + 1]
			
			if prev + next == Vector2i.ZERO:
				sprite.frame_coords = BODY_STRAIGHT.coords
				sprite.rotation_degrees = get_straight_torso_rotation(prev, next)
				
			else:
				sprite.frame_coords = BODY_CORNER.coords
				sprite.rotation_degrees = get_corner_torso_rotation(prev, next)

func get_tail_rotation(prev: Vector2i) -> int:
	return get_head_rotation(prev) - 180

func get_head_rotation(next: Vector2i) -> int:
	match next:
		UP: return 0
		RIGHT: return 90
		DOWN: return 180
		LEFT: return 270
		
	assert(false)
	return 0

# determine rotation of straight torso sprite, based on direction to previous and next tile
func get_straight_torso_rotation(prev: Vector2i, next: Vector2i) -> int:
	if prev.x == 0:
		return 0
	else:
		return 90
	
# determine rotation of corner torso sprite, based on direction to previous and next tile
func get_corner_torso_rotation(prev: Vector2i, next: Vector2i) -> int:
	var x_axis: Vector2i
	var y_axis: Vector2i

	if prev.x == 0:
		x_axis = next
		y_axis = prev
	else:
		x_axis = prev
		y_axis = next
		
	if x_axis == LEFT:
		if y_axis == UP:
			return 90
		else:
			return 0
			
	else:
		if y_axis == UP:
			return 180
		else:
			return 270
	

func spawn_sprites_if_necessary() -> void:
	assert($Sprites.get_child_count() <= coords.size())
	
	while $Sprites.get_child_count() < coords.size():
		print("Making additional snake sprite")
		var sprite = Sprite2D.new()

		assert(sprite_sheet)
		sprite.texture = sprite_sheet
		sprite.hframes = sprite_sheet_size.x
		sprite.vframes = sprite_sheet_size.y
		
		sprite.frame_coords = BODY_STRAIGHT.coords # we'll set the correct value later
	
		$Sprites.add_child(sprite)

class RSprite:
	# Position of the sprite in the sprite sheet
	var coords: Vector2i
	var name: String
	
	func _init(_coords: Vector2i, _name: String):
		coords = _coords
		name = _name