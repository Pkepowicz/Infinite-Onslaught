GDPC                p                                                                         T   res://.godot/exported/133200997/export-0db2d386c3a60fa12e665737a8266d7c-player.scn  P	      �      �@Ɏ�E>*���8?)��    T   res://.godot/exported/133200997/export-57acc274dc73092f753a0b506eff1f3a-bullet.scn  �       !      ����+�t�'�H�j�    T   res://.godot/exported/133200997/export-f30a33e250f7981f71ef3d17b6197292-world.scn          =      �������̓��O=j%    ,   res://.godot/global_script_class_cache.cfg  P-             ��Р�8���8~$}P�    D   res://.godot/imported/icon.svg-56083ea2a1f1a4f1e49773bdc6d7826c.ctex`      �      �̛�*$q�*�́        res://.godot/uid_cache.bin  01      �       `[
�H9�r�����       res://assets/icon.svg   p-      �      C��=U���^Qu��U3       res://assets/icon.svg.import@+      �       ɔO��%xK	��]6�        res://assets/player/Player.gd         ;      E��V�d���^�2�    (   res://assets/player/player.tscn.remap   p,      c       ��]�*��2ZbdXp��    (   res://assets/player/weapons/Bullet.gd           �       ���#~j
ӄq���    0   res://assets/player/weapons/bullet.tscn.remap    ,      c       �:�$P�_����T�       res://assets/scenes/world.gdP      �      ���{�h�6&l�q�    $   res://assets/scenes/world.tscn.remap�,      b       ��a�������cz΢       res://project.binary�1      �      �Ƀ�Q.�}�}K�3Z�z        extends CharacterBody2D


const SPEED = 500.0
var direction : Vector2

func _ready():
	direction = Vector2(1,0).rotated(rotation)

func _physics_process(delta):

	velocity = SPEED * direction

	move_and_slide()
             RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script &   res://assets/player/weapons/Bullet.gd ��������
   Texture2D    res://assets/icon.svg ���2)�	      local://RectangleShape2D_l3bwk �         local://PackedScene_fyx8y �         RectangleShape2D       
     �B  B         PackedScene          	         names "   	      Bullet    script    CharacterBody2D 	   Sprite2D 	   position    scale    texture    CollisionShape2D    shape    	   variants                 
     \B    
     X? �>         
     ZB                    node_count             nodes     !   ��������       ����                            ����                                       ����                         conn_count              conns               node_paths              editable_instances              version             RSRC               extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var bullet : PackedScene

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	$GunRotation.look_at(get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("Fire"):
		Fire.rpc()
	var direction_x = Input.get_axis("ui_left", "ui_right")
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()

@rpc("any_peer", "call_local")
func Fire():
	var b = bullet.instantiate()
	b.global_position = $GunRotation/BulletSpawn.global_position
	b.rotation_degrees = $GunRotation.rotation_degrees
	get_tree().root.add_child(b)
     RSRC                    PackedScene            ��������                                                  . 	   position    GunRotation 	   rotation    resource_local_to_scene    resource_name    custom_solver_bias    size    script    properties/0/path    properties/0/spawn    properties/0/sync    properties/0/watch    properties/1/path    properties/1/spawn    properties/1/sync    properties/1/watch 	   _bundled       Script    res://assets/player/Player.gd ��������   PackedScene (   res://assets/player/weapons/bullet.tscn X�G�Q
   Texture2D    res://assets/icon.svg ���2)�	      local://RectangleShape2D_8b4qh       #   local://PlaceholderTexture2D_rnois I      %   local://SceneReplicationConfig_g3wg3 n         local://PackedScene_ggx4c          RectangleShape2D       
     C  C         PlaceholderTexture2D             SceneReplicationConfig 	   	               
                                                                               PackedScene          	         names "         Player    scale    collision_layer    collision_mask    script    bullet    CharacterBody2D    PlayerSprite    texture 	   Sprite2D    CollisionShape2D 	   position    shape    GunRotation    Node2D    WeaponSprite    BulletSpawn    MultiplayerSynchronizer    replication_config    	   variants       
      ?   ?                                   
     �?   �          
     �B �4
     B  B         
     �B   @               node_count             nodes     L   ��������       ����                                                 	      ����                     
   
   ����                                 ����               	      ����                  	                    ����      
                     ����                   conn_count              conns               node_paths              editable_instances              version             RSRC extends Node2D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry

const Player = preload("res://assets/player/player.tscn")
const PORT = 2456
var enet_peer = WebSocketMultiplayerPeer.new()

func _ready():
	if '--server' in OS.get_cmdline_args():
		host_server()

func host_server():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	print("Waiting for players!")

func _on_join_button_button_down():
	print("Trying to connect")
	main_menu.hide()
	
	enet_peer.create_client(address_entry.text + ':' + str(PORT))
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	print("Connected: " + str(peer_id) )
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)

func remove_player(peer_id):
	print("Disconnected: " + str(peer_id) )
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_host_button_button_down():
	host_server()
	add_player(multiplayer.get_unique_id())

func _process(delta):
	enet_peer.poll()
          RSRC                    PackedScene            ��������                                                  ..    resource_local_to_scene    resource_name 	   _bundled    script       Script    res://assets/scenes/world.gd ��������      local://PackedScene_s7k6l          PackedScene          	         names "   '      world    script    Node2D    CanvasLayer 	   MainMenu    anchors_preset    anchor_right    anchor_bottom    offset_left    offset_top    offset_right    offset_bottom    grow_horizontal    grow_vertical    PanelContainer    MarginContainer    layout_mode %   theme_override_constants/margin_left $   theme_override_constants/margin_top &   theme_override_constants/margin_right '   theme_override_constants/margin_bottom    VBoxContainer $   theme_override_constants/separation    Label    text    horizontal_alignment    HostButton    Button    JoinButton    AddressEntry    placeholder_text 
   alignment 	   LineEdit    MultiplayerSpawner    _spawnable_scenes    spawn_path    _on_host_button_button_down    button_down    _on_join_button_button_down    	   variants                            �?     �C     pC     ��     p�         
   Main Menu             Host       Join       Ip address "          res://assets/player/player.tscn                 node_count    
         nodes     �   ��������       ����                            ����                     ����	                           	      
                                         ����                                                  ����                                ����                  	                    ����            
                    ����                                 ����                  	               !   !   ����   "      #                conn_count             conns               %   $                     %   &                    node_paths              editable_instances              version             RSRC   GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[             [remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://j4yhfjykaftm"
path="res://.godot/imported/icon.svg-56083ea2a1f1a4f1e49773bdc6d7826c.ctex"
metadata={
"vram_texture": false
}
 [remap]

path="res://.godot/exported/133200997/export-57acc274dc73092f753a0b506eff1f3a-bullet.scn"
             [remap]

path="res://.godot/exported/133200997/export-0db2d386c3a60fa12e665737a8266d7c-player.scn"
             [remap]

path="res://.godot/exported/133200997/export-f30a33e250f7981f71ef3d17b6197292-world.scn"
              list=Array[Dictionary]([])
     <svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
             X�G�Q'   res://assets/player/weapons/bullet.tscn}gҮ�   res://assets/player/player.tscnx�ݽ�MN   res://assets/scenes/world.tscn���2)�	   res://assets/icon.svg   ECFG      application/config/name         Infinite Onslaught     application/run/main_scene(         res://assets/scenes/world.tscn     application/config/features(   "         4.1    GL Compatibility       application/config/icon          res://assets/icon.svg   
   input/Fire�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         canceled          pressed           double_click          script      #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility  