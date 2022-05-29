import nigui, nigui/msgbox, strutils
import bounds, profile, launcher, custom_widgets

proc init*() =
  app.init()

  # init window
  var bounds = load_bounds()

  var win = newWindow("VRCChanger")

  win.width = bounds.w.scaleToDpi
  win.height = bounds.h.scaleToDpi
  win.x = bounds.x
  win.y = bounds.y

  win.onCloseClick = proc(event: CloseClickEvent) =
    write_bounds(win.x, win.y, win.width, win.height)
    echo "exit"
    win.dispose()

  # layout

  # Main
  #   Settings
  #     do_not_close
  #     vr_mode
  #     profile
  #     custom_home_world
  #     other_option
  #
  #     DebugContainer
  #       debug
  #       DebugSubContainer
  #         debug_gui
  #         debug_log
  #         debug_udon_log
  #         debug_ik_log
  #
  #     WindowContainer
  #       window
  #       WindowSubContainer
  #         full_screen
  #         max_fps
  #         screen_w
  #         screen_h
  #
  #     IKContainer
  #       ik
  #       IKSubContainer
  #         legacy_fbt
  #         custom_arm_ratio
  #         disable_shoulder_tracking
  #         calibration_range
  #         freeze_tracking_on_disconnect
  #
  #     OSCContainer
  #       osc
  #         osc_in_port
  #         osc_out_ip
  #         osc_out_port
  #   Buttons
  var main_layout = newLayoutContainer(Layout_Vertical)
  main_layout.padding = 4

  var setting_area = newLayoutContainer(Layout_Vertical)
  setting_area.padding = 2
  setting_area.spacing = 1

  var button_area = newLayoutContainer(Layout_Horizontal)
  button_area.padding = 2

  var debug_container = newLayoutContainer(Layout_Vertical)
  debug_container.padding = 0
  debug_container.spacing = 1

  var debug_sub_container = newLayoutContainer(Layout_Vertical)
  debug_sub_container.padding = 0
  debug_sub_container.spacing = 1

  var window_container = newLayoutContainer(Layout_Vertical)
  window_container.padding = 0
  window_container.spacing = 1

  var window_sub_container = newLayoutContainer(Layout_Vertical)
  window_sub_container.padding = 0
  window_sub_container.spacing = 1

  var ik_container = newLayoutContainer(Layout_Vertical)
  ik_container.padding = 0
  ik_container.spacing = 1

  var ik_sub_container = newLayoutContainer(Layout_Vertical)
  ik_sub_container.padding = 0
  ik_sub_container.spacing = 1

  var osc_container = newLayoutContainer(Layout_Vertical)
  osc_container.padding = 0
  osc_container.spacing = 1

  var osc_sub_container = newLayoutContainer(Layout_Vertical)
  osc_sub_container.padding = 0
  osc_sub_container.spacing = 1

  main_layout.add(setting_area)
  main_layout.add(button_area)

  win.add(main_layout)

  # settings
  #   top
  var do_not_close_checkbox = newCustomCheckbox("VRC起動後も開いたままにする")
  var mode_checkbox = newCustomCheckbox("VRMode")
  var profile_box = newCustomTextBox("Profile")
  var custom_home_world_box = newCustomTextBox("Custom home world")
  var other_option_box = newCustomTextBox("Other option")

  #   debug
  var debug_checkbox = newCustomCheckbox("▷ Debug")
  debug_container.add(debug_checkbox.container)
  debug_container.add(debug_sub_container)

  var debug_gui_checkbox = newCustomCheckbox("  Debug gui")
  debug_sub_container.add(debug_gui_checkbox.container)

  var debug_log_checkbox = newCustomCheckbox("  SDK log levels")
  debug_sub_container.add(debug_log_checkbox.container)

  var debug_udon_log_checkbox = newCustomCheckbox("  Udon debug logging")
  debug_sub_container.add(debug_udon_log_checkbox.container)

  var debug_ik_log_checkbox = newCustomCheckbox("  IK debug logging")
  debug_sub_container.add(debug_ik_log_checkbox.container)

  #   window
  var window_checkbox = newCustomCheckbox("▷ Window")
  window_container.add(window_checkbox.container)
  window_container.add(window_sub_container)

  var full_screen_checkbox = newCustomCheckbox("  FullScreen")
  window_sub_container.add(full_screen_checkbox.container)

  var max_fps_box = newCustomTextBox("  Max FPS(only Desktop)")
  window_sub_container.add(max_fps_box.container)

  var screen_w_box = newCustomTextBox("  Screen Width")
  window_sub_container.add(screen_w_box.container)

  var screen_h_box = newCustomTextBox("  Screen Height")
  window_sub_container.add(screen_h_box.container)

  #   ik
  var ik_checkbox = newCustomCheckbox("▷ IK")
  ik_container.add(ik_checkbox.container)
  ik_container.add(ik_sub_container)

  var legacy_fbt_checkbox = newCustomCheckbox("  Legacy FBT calibrate")
  ik_sub_container.add(legacy_fbt_checkbox.container)

  var custom_arm_ratio_box = newCustomTextBox("  Custom arm ratio")
  ik_sub_container.add(custom_arm_ratio_box.container)

  var disable_shoulder_tracking_checkbox = newCustomCheckbox("  Disable shoulder tracking")
  ik_sub_container.add(disable_shoulder_tracking_checkbox.container)

  var calibration_range_box = newCustomTextBox("  Calibration range")
  ik_sub_container.add(calibration_range_box.container)

  var freeze_tracking_on_disconnect_checkbox = newCustomCheckbox("  Freeze tracking on disconnect")
  ik_sub_container.add(freeze_tracking_on_disconnect_checkbox.container)

  var osc_checkbox = newCustomCheckbox("▷ OSC")
  osc_container.add(osc_checkbox.container)
  osc_container.add(osc_sub_container)

  var osc_in_port_box = newCustomTextBox("  in Port")
  osc_sub_container.add(osc_in_port_box.container)

  var osc_out_ip_box = newCustomTextBox("  out IP")
  osc_sub_container.add(osc_out_ip_box.container)

  var osc_out_port_box = newCustomTextBox("  out Port")
  osc_sub_container.add(osc_out_port_box.container)

  setting_area.add(do_not_close_checkbox.container)
  setting_area.add(mode_checkbox.container)
  setting_area.add(profile_box.container)
  setting_area.add(custom_home_world_box.container)
  setting_area.add(other_option_box.container)
  setting_area.add(debug_container)
  setting_area.add(window_container)
  setting_area.add(ik_container)
  setting_area.add(osc_container)

  # buttons
  var save_button = newButton("Save")
  var launch_button = newButton("Launch")

  button_area.add(save_button)
  button_area.add(launch_button)

  debug_checkbox.onToggle = proc(event: ToggleEvent) = debug_sub_container.visible = debug_checkbox.checked
  window_checkbox.onToggle = proc(event: ToggleEvent) = window_sub_container.visible = window_checkbox.checked
  ik_checkbox.onToggle = proc(event: ToggleEvent) = ik_sub_container.visible = ik_checkbox.checked
  osc_checkbox.onToggle = proc(event: ToggleEvent) = osc_sub_container.visible = osc_checkbox.checked

  # profile
  var profile = load_profile()

  do_not_close_checkbox.checked = profile.do_not_close
  mode_checkbox.checked = profile.vr_mode
  profile_box.text = $(profile.profile)
  custom_home_world_box.text = profile.custom_home_world
  other_option_box.text = profile.other_option
  debug_checkbox.checked = profile.debug
  debug_gui_checkbox.checked = profile.debug_gui
  debug_log_checkbox.checked = profile.debug_log
  debug_udon_log_checkbox.checked = profile.debug_udon_log
  debug_ik_log_checkbox.checked = profile.debug_ik_log
  window_checkbox.checked = profile.window
  full_screen_checkbox.checked = profile.full_screen
  max_fps_box.text = $(profile.max_fps)
  screen_w_box.text = $(profile.screen_width)
  screen_h_box.text = $(profile.screen_height)
  ik_checkbox.checked = profile.ik
  legacy_fbt_checkbox.checked = profile.legacy_fbt
  custom_arm_ratio_box.text = $(profile.custom_arm_ratio)
  disable_shoulder_tracking_checkbox.checked = profile.disable_shoulder_tracking
  freeze_tracking_on_disconnect_checkbox.checked = profile.freeze_tracking_on_disconnect
  calibration_range_box.text = $(profile.calibration_range)
  osc_checkbox.checked = profile.osc
  osc_in_port_box.text = profile.osc_in_port
  osc_out_ip_box.text = profile.osc_out_ip
  osc_out_port_box.text = profile.osc_out_port

  debug_sub_container.visible = debug_checkbox.checked
  window_sub_container.visible = window_checkbox.checked
  ik_sub_container.visible = ik_checkbox.checked
  osc_sub_container.visible = osc_checkbox.checked

  # events
  save_button.onClick = proc(event: ClickEvent) =
    var profile_int, max_fps_int, screen_width_int, screen_height_int: int
    var custom_arm_ratio_float, calibration_range_float: float
    try:
      profile_int = profile_box.text.parseInt
      max_fps_int = max_fps_box.text.parseInt
      screen_width_int = screen_w_box.text.parseInt
      screen_height_int = screen_h_box.text.parseInt
      custom_arm_ratio_float = custom_arm_ratio_box.text.parseFloat
      calibration_range_float = calibration_range_box.text.parseFloat
    except ValueError:
      # 多分2バイト文字だから長さ正しく取れてない
      win.msgBox("テキストボックスにテキストを入れないで              ")
      return
    except:
      echo repr(getCurrentException())
      return

    var profile = new_profile(
      do_not_close_checkbox.checked,
      mode_checkbox.checked,
      profile_int,
      custom_home_world_box.text,
      other_option_box.text,
      debug_checkbox.checked,
      debug_gui_checkbox.checked,
      debug_log_checkbox.checked,
      debug_udon_log_checkbox.checked,
      debug_ik_log_checkbox.checked,
      window_checkbox.checked,
      full_screen_checkbox.checked,
      max_fps_int,
      screen_width_int,
      screen_height_int,
      ik_checkbox.checked,
      legacy_fbt_checkbox.checked,
      disable_shoulder_tracking_checkbox.checked,
      freeze_tracking_on_disconnect_checkbox.checked,
      custom_arm_ratio_float,
      calibration_range_float,
      osc_checkbox.checked,
      osc_in_port_box.text,
      osc_out_ip_box.text,
      osc_out_port_box.text
    )

    write_profile(profile)
    win.msgBox("Save done!")

  launch_button.onClick = proc(event: ClickEvent) =
    var profile_int, max_fps_int, screen_width_int, screen_height_int: int
    var custom_arm_ratio_float, calibration_range_float: float
    try:
      profile_int = profile_box.text.parseInt
      max_fps_int = max_fps_box.text.parseInt
      screen_width_int = screen_w_box.text.parseInt
      screen_height_int = screen_h_box.text.parseInt
      custom_arm_ratio_float = custom_arm_ratio_box.text.parseFloat
      calibration_range_float = calibration_range_box.text.parseFloat
    except ValueError:
      # 多分2バイト文字だから長さ正しく取れてない
      win.msgBox("テキストボックスにテキストを入れないで              ")
      return
    except:
      echo repr(getCurrentException())
      return

    var profile = new_profile(
      do_not_close_checkbox.checked,
      mode_checkbox.checked,
      profile_int,
      custom_home_world_box.text,
      other_option_box.text,
      debug_checkbox.checked,
      debug_gui_checkbox.checked,
      debug_log_checkbox.checked,
      debug_udon_log_checkbox.checked,
      debug_ik_log_checkbox.checked,
      window_checkbox.checked,
      full_screen_checkbox.checked,
      max_fps_int,
      screen_width_int,
      screen_height_int,
      ik_checkbox.checked,
      legacy_fbt_checkbox.checked,
      disable_shoulder_tracking_checkbox.checked,
      freeze_tracking_on_disconnect_checkbox.checked,
      custom_arm_ratio_float,
      calibration_range_float,
      osc_checkbox.checked,
      osc_in_port_box.text,
      osc_out_ip_box.text,
      osc_out_port_box.text
    )

    launcher.exec(profile)

  win.show()
  app.run()

