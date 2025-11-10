extends Player
class_name PlayerController

static var instance: PlayerController

##Written by AI, im forgot how to make player fps controller.

@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.004

@export_category("Dependencies")
@export var camera: Camera3D

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	instance = self
	
	# Проверка необходимых компонентов
	if !camera:
		push_error("Player: Camera3D not assigned!")
	
	# Настройка синхронизации
	$NetworkSyncClient.appendSyncProperty("position")
	$NetworkSyncClient.appendSyncProperty("rotation")
	
	# Настройка ввода
	get_window().focus_entered.connect(process_focus)
	get_window().focus_exited.connect(process_focus)

func process_focus():
	if get_window().has_focus():
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass

func _physics_process(delta: float) -> void:
	# Применяем гравитацию
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Обработка движения
	handle_movement(delta)
	
	move_and_slide()
	$NetworkSyncClient.sync()

const friction:float = 0.9

func handle_movement(delta: float) -> void:
	var input_dir:Vector2 = Input.get_vector("move_left", "move_right", "move_tow", "move_back")
	var direction:Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	

	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
		
		# Прыжок
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	else:
		# Воздушное управление
		if direction:
			velocity.x = move_toward(velocity.x, direction.x * speed, speed * delta)
			velocity.z = move_toward(velocity.z, direction.z * speed, speed * delta)
		
		if input_dir == Vector2.ZERO:
			velocity.x*=friction
			velocity.z*=friction

func _input(event: InputEvent) -> void:
	# Вращение камеры
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * mouse_sensitivity)
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	# Переключение режима мыши
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			toggle_mouse_capture()

func toggle_mouse_capture() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Сетевые методы
func setId(id: int) -> void:
	$NetworkSyncClient.setId(id)

func get_id() -> int:
	return $NetworkSyncClient.get_id()
