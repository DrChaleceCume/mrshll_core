ModRegisterAudioEventMappings( "mods/mrshll_core/GUIDs.txt" )

function OnPlayerSpawned( hooman )
	dofile_once( "mods/mrshll_core/lib.lua" )
	
	local initer = "HERMES_MARSHALL_MOMENT"
	if( GameHasFlagRun( initer )) then
		return
	end
	GameAddFlagRun( initer )
	
	GlobalsSetValue( "HERMES_IS_REAL", "1" )
	
	local mode = ModSettingGetNextValue( "mrshll_core.ITEM_INIT" )
	if( mode < 4 ) then
		local x, y = EntityGetTransform( hooman )
		
		local override = ModIsEnabled( "white_room" ) and mode < 3
		if( override ) then
			x, y = 1727, 5328
		end
		
		local controller = EntityLoad( "mods/mrshll_core/mrshll/item.xml", x, y )
		ComponentSetValue2( get_storage( controller, "sound_volume" ), "value_float", ModSettingGetNextValue( "mrshll_core.VOLUME" ))
		ComponentSetValue2( get_storage( controller, "random_order" ), "value_bool", ModSettingGetNextValue( "mrshll_core.IS_SHUFFLED" ) or false )
		ComponentSetValue2( get_storage( controller, "playlist_num" ), "value_int", ModSettingGetNextValue( "mrshll_core.PLAYLIST" ))
		for i = 1,3 do
			ComponentSetValue2( get_storage( controller, "ignored_songs_"..i ), "value_string", ModSettingGetNextValue( "mrshll_core.IGNORE_LIST_"..i ))
			ComponentSetValue2( get_storage( controller, "ordered_songs_"..i ), "value_string", ModSettingGetNextValue( "mrshll_core.ORDER_LIST_"..i ))
		end
		if( mode < 3 ) then
			EntityAddTag( controller, "teleportable_NOT" )
			EntityAddTag( controller, "item_physics" )
			EntityAddTag( controller, "item_pickup" )
			EntitySetComponentIsEnabled( controller, EntityAddComponent( controller, "PhysicsBodyComponent",
			{
				_tags = "enabled_in_world",
				uid = "1", 
				allow_sleep = "1",
				angular_damping = "0", 
				fixed_rotation = "0", 
				is_bullet = "1", 
				linear_damping = "0",
				auto_clean = "0",
				kills_entity = "1",
				hax_fix_going_through_ground = "1",
				on_death_leave_physics_body = "1",
				on_death_really_leave_body = "1",
			}), false )
			EntityAddComponent( controller, "PhysicsImageShapeComponent",
			{
				body_id = "1",
				centered = "1",
				image_file = "mods/mrshll_core/mrshll/item.png",
				material = CellFactory_GetType( "templebrick_diamond_static" ),
			})
			EntitySetComponentIsEnabled( controller, EntityAddComponent( controller, "SpriteComponent",
			{
				_tags = "enabled_in_hand",
				offset_x = "2",
				offset_y = "5",
				image_file = "mods/mrshll_core/mrshll/item.png",
				z_index = "-10",
			}), true )
			EntitySetComponentIsEnabled( controller, EntityAddComponent( controller, "VelocityComponent",
			{
				_tags = "enabled_in_world",
			}), false )
			ComponentSetValue2( EntityAddComponent( controller, "ItemComponent",
			{
				_tags = "enabled_in_world",
				item_name = "HermeS Marshall©",
				max_child_items = "0",
				is_pickable = "1",
				is_equipable_forced = "1",
				always_use_item_name_in_ui = "1",
				ui_sprite = "mods/mrshll_core/mrshll/item_ui.png",
				ui_description = "Manufactured by Hermeneutics Superior FRC.\nIt shimmers with tunes.",
				play_spinning_animation = "0",
			}), "preferred_inventory", "QUICK" )
			ComponentObjectSetValue2( EntityAddComponent( controller, "AbilityComponent",
			{
				throw_as_item = "0",
			}), "gun_config", "deck_capacity", 0 )
			
			local steam = EntityAddComponent( controller, "SpriteParticleEmitterComponent", 
			{
				_tags = "enabled_in_world",
				sprite_file = "mods/mrshll_core/mrshll/gold.png",
				sprite_centered = "1",
				lifetime = "3",
				velocity_slowdown = "0",
				use_velocity_as_rotation = "1",
				z_index = "100",
				delay = "0",
				additive = "1",
				emissive = "1",
				count_min = "0",
				count_max = "1",
				velocity_always_away_from_center = "0",
				emission_interval_min_frames = "2",
				emission_interval_max_frames = "5",
				is_emitting = "1",
				render_back = "0",
			})
			EntitySetComponentIsEnabled( controller, steam, not( override ))
			ComponentSetValue2( steam, "randomize_position", -6, 6, 6, -6 )
			ComponentSetValue2( steam, "velocity", 0, 5 )
			ComponentSetValue2( steam, "randomize_velocity", -0.5, -6, 0.5, -4.99 )
			ComponentSetValue2( steam, "scale", 0.7, 0.7 )
			ComponentSetValue2( steam, "randomize_scale", -0.1, -0.1, 0.1, 0.1 )
			ComponentSetValue2( steam, "color", 199/255, 220/255, 208/255, 0.3 )
			ComponentSetValue2( steam, "color_change", 0.03, 0.03, 0.03, -0.03 )
			
			if( override ) then
				GamePrint( "::Injection Protocol Override:: Destination set to [THE CHAMBER]" )
				EntitySetTransform( controller, x, y, 0, -1, 1 )
			elseif( mode == 1 ) then
				GamePickUpInventoryItem( hooman, controller, false )
			end
		else
			EntityAddComponent( controller, "VariableStorageComponent",
			{
				name = "is_open",
				value_bool = "0",
			})
			EntityAddComponent( controller, "InheritTransformComponent" )
			EntityAddChild( hooman, controller )
		end
	end
end