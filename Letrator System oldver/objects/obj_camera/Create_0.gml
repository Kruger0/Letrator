#region CAMERA SETTINGS
cam = view_camera[0]
cam_scale = 4
game_width = 1920/cam_scale
game_height = 1080/cam_scale

window_scale = 2
window_set_size(game_width*window_scale, game_height*window_scale);

camera_set_view_size(cam, game_width, game_height)

gui_scale = 1.3
display_set_gui_size(game_width*gui_scale, game_height*gui_scale);
surface_resize(application_surface, game_width*window_scale, game_height*window_scale)
alarm[0] = 1

#endregion
