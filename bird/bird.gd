class_name Bird
extends RigidBody2D

enum GravityDirection {
	NONE = 0,
	UP = -1, 
	DOWN = 1
}

var gravity_direction: GravityDirection:
	set(v):
		gravity_direction = v
		PhysicsServer2D.area_set_param(
			get_viewport().find_world_2d().space,
			PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR,
			Vector2(0, gravity_direction)
		)
var dead: bool:
	set(v):
		dead = v
		_sprite_normal.visible = not dead
		_sprite_dead.visible = dead

@export var _speed: float = 100
@export_group("Component")
@export var _pipe_manager: PipeManager
@export var _visible_on_screen_notifier: VisibleOnScreenNotifier2D
@export var _sprite_normal: Sprite2D
@export var _sprite_dead: Sprite2D

var _next_pipe: Pipe

func _init() -> void:
	body_entered.connect(_body_entered)

func _enter_tree() -> void:
	_pipe_manager.pipe_appended.connect(_update_next_pipe)

func _idle_state_entered() -> void:
	dead = false
	global_position = Vector2.ZERO
	rotation = 0
	gravity_direction = GravityDirection.NONE
	freeze = false

func _game_state_processing(_delta: float) -> void:
	if _next_pipe != null and global_position.x > _next_pipe.global_position.x:
		Main.node().score += 1
		_update_next_pipe()

func _game_or_idle_state_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("invert_gravity_direction"):
		MainState.chart().send_event("game_start")
		if gravity_direction == GravityDirection.NONE:
			gravity_direction = GravityDirection.DOWN
		else:
			gravity_direction = -gravity_direction as GravityDirection

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = Vector2(_speed, state.linear_velocity.y)
	match gravity_direction:
		GravityDirection.NONE: rotation = 0
		GravityDirection.UP: rotation = -(TAU / 8 * 1)
		GravityDirection.DOWN: rotation = TAU / 8 * 1

func _body_entered(body: Node) -> void:
	if body is Pipe:
		set_deferred("freeze", true)
		await get_tree().create_timer(0.5).timeout
		
		dead = true
		rotation = -(TAU / 4)
		var gravity := sqrt(ProjectSettings.get_setting_with_override("physics/2d/default_gravity"))
		var vel_y := -8.5
		while global_position.y < 0 or _visible_on_screen_notifier.is_on_screen():
			await get_tree().process_frame
			global_position += Vector2(0, vel_y)
			vel_y += gravity * get_process_delta_time()
		
		MainState.chart().send_event("game_over")

func _update_next_pipe() -> void:
	_next_pipe = null
	_pipe_manager.pipes.any(func(pipe: Pipe) -> bool:
		if pipe.index == Main.node().score:
			_next_pipe = pipe
			return true
		return false
	)
