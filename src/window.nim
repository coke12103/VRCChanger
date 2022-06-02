import niup, niup/niupc, strutils
import bounds, profile, launcher, custom_widgets

proc close_proc(ih: PIhandle):cint {.cdecl.} =
  var main_window = Dialog_t(niup.GetHandle("main_window"))
  var rastersize_arr = main_window.rastersize.split("x")
  var
    w = rastersize_arr[0].parseInt
    h = rastersize_arr[1].parseInt
    x = main_window.x.parseInt
    y = main_window.y.parseInt

  write_bounds(x, y, w, h)
  echo "exit"

proc parse_bool(from_str: string):bool =
  result = (from_str == "YES" or from_str == "ON")

proc parse_bool(from_bool: bool, is_switch = true):string =
  var ret_val = ""

  if from_bool:
    ret_val = if is_switch: "ON" else: "YES"
  else:
    ret_val = if is_switch: "OFF" else: "NO"
  result = ret_val

proc save_profile() =
  var do_not_close_checkbox = Toggle_t(niup.GetHandle("do_not_close_checkbox"))
  var mode_checkbox = Toggle_t(niup.GetHandle("mode_checkbox"))
  var debug_enable_checkbox = Toggle_t(niup.GetHandle("debug_enable_checkbox"))
  var debug_gui_checkbox = Toggle_t(niup.GetHandle("debug_gui_checkbox"))
  var debug_log_checkbox = Toggle_t(niup.GetHandle("debug_log_checkbox"))
  var debug_udon_log_checkbox = Toggle_t(niup.GetHandle("debug_udon_log_checkbox"))
  var debug_ik_log_checkbox = Toggle_t(niup.GetHandle("debug_ik_log_checkbox"))
  var window_enable_checkbox = Toggle_t(niup.GetHandle("window_enable_checkbox"))
  var full_screen_checkbox = Toggle_t(niup.GetHandle("full_screen_checkbox"))
  var ik_enable_checkbox = Toggle_t(niup.GetHandle("ik_enable_checkbox"))
  var legacy_fbt_checkbox = Toggle_t(niup.GetHandle("legacy_fbt_checkbox"))
  var disable_shoulder_tracking_checkbox = Toggle_t(niup.GetHandle("disable_shoulder_tracking_checkbox"))
  var freeze_tracking_on_disconnect_checkbox = Toggle_t(niup.GetHandle("freeze_tracking_on_disconnect_checkbox"))
  var osc_enable_checkbox = Toggle_t(niup.GetHandle("osc_enable_checkbox"))

  var profile_spin = Text_t(niup.GetHandle("profile_spin"))
  var max_fps_spin = Text_t(niup.GetHandle("max_fps_spin"))
  var screen_w_spin = Text_t(niup.GetHandle("screen_w_spin"))
  var screen_h_spin = Text_t(niup.GetHandle("screen_h_spin"))

  var custom_arm_ratio_spin = Text_t(niup.GetHandle("custom_arm_ratio_spin"))
  var calibration_range_spin = Text_t(niup.GetHandle("calibration_range_spin"))

  var osc_in_port_textbox = Text_t(niup.GetHandle("osc_in_port_textbox"))
  var osc_out_ip_textbox = Text_t(niup.GetHandle("osc_out_ip_textbox"))
  var osc_out_port_textbox = Text_t(niup.GetHandle("osc_out_port_textbox"))
  var custom_home_world_textbox = Text_t(niup.GetHandle("custom_home_world_textbox"))
  var other_option_textbox = Text_t(niup.GetHandle("other_option_textbox"))

  var profile_int, max_fps_int, screen_width_int, screen_height_int: int
  var custom_arm_ratio_float, calibration_range_float: float
  try:
    profile_int = profile_spin.spinvalue.parseInt
    max_fps_int = max_fps_spin.spinvalue.parseInt
    screen_width_int = screen_w_spin.spinvalue.parseInt
    screen_height_int = screen_h_spin.spinvalue.parseInt
    custom_arm_ratio_float = custom_arm_ratio_spin.value.parseFloat
    calibration_range_float = calibration_range_spin.value.parseFloat

  except ValueError:
    niup.Message("エラー" ,"値のパースに失敗した")
    return
  except:
    echo repr(getCurrentException())
    return

  var prof = new_profile(
    parse_bool(do_not_close_checkbox.value),
    parse_bool(mode_checkbox.value),
    profile_int,
    custom_home_world_textbox.value,
    other_option_textbox.value,
    parse_bool(debug_enable_checkbox.value),
    parse_bool(debug_gui_checkbox.value),
    parse_bool(debug_log_checkbox.value),
    parse_bool(debug_udon_log_checkbox.value),
    parse_bool(debug_ik_log_checkbox.value),
    parse_bool(window_enable_checkbox.value),
    parse_bool(full_screen_checkbox.value),
    max_fps_int,
    screen_width_int,
    screen_height_int,
    parse_bool(ik_enable_checkbox.value),
    parse_bool(legacy_fbt_checkbox.value),
    parse_bool(disable_shoulder_tracking_checkbox.value),
    parse_bool(freeze_tracking_on_disconnect_checkbox.value),
    custom_arm_ratio_float,
    calibration_range_float,
    parse_bool(osc_enable_checkbox.value),
    osc_in_port_textbox.value,
    osc_out_ip_textbox.value,
    osc_out_port_textbox.value
  )

  write_profile(prof)
  niup.Message("Message", "Save done!")


proc launch_profile() =
  var do_not_close_checkbox = Toggle_t(niup.GetHandle("do_not_close_checkbox"))
  var mode_checkbox = Toggle_t(niup.GetHandle("mode_checkbox"))
  var debug_enable_checkbox = Toggle_t(niup.GetHandle("debug_enable_checkbox"))
  var debug_gui_checkbox = Toggle_t(niup.GetHandle("debug_gui_checkbox"))
  var debug_log_checkbox = Toggle_t(niup.GetHandle("debug_log_checkbox"))
  var debug_udon_log_checkbox = Toggle_t(niup.GetHandle("debug_udon_log_checkbox"))
  var debug_ik_log_checkbox = Toggle_t(niup.GetHandle("debug_ik_log_checkbox"))
  var window_enable_checkbox = Toggle_t(niup.GetHandle("window_enable_checkbox"))
  var full_screen_checkbox = Toggle_t(niup.GetHandle("full_screen_checkbox"))
  var ik_enable_checkbox = Toggle_t(niup.GetHandle("ik_enable_checkbox"))
  var legacy_fbt_checkbox = Toggle_t(niup.GetHandle("legacy_fbt_checkbox"))
  var disable_shoulder_tracking_checkbox = Toggle_t(niup.GetHandle("disable_shoulder_tracking_checkbox"))
  var freeze_tracking_on_disconnect_checkbox = Toggle_t(niup.GetHandle("freeze_tracking_on_disconnect_checkbox"))
  var osc_enable_checkbox = Toggle_t(niup.GetHandle("osc_enable_checkbox"))

  var profile_spin = Text_t(niup.GetHandle("profile_spin"))
  var max_fps_spin = Text_t(niup.GetHandle("max_fps_spin"))
  var screen_w_spin = Text_t(niup.GetHandle("screen_w_spin"))
  var screen_h_spin = Text_t(niup.GetHandle("screen_h_spin"))

  var custom_arm_ratio_spin = Text_t(niup.GetHandle("custom_arm_ratio_spin"))
  var calibration_range_spin = Text_t(niup.GetHandle("calibration_range_spin"))

  var osc_in_port_textbox = Text_t(niup.GetHandle("osc_in_port_textbox"))
  var osc_out_ip_textbox = Text_t(niup.GetHandle("osc_out_ip_textbox"))
  var osc_out_port_textbox = Text_t(niup.GetHandle("osc_out_port_textbox"))
  var custom_home_world_textbox = Text_t(niup.GetHandle("custom_home_world_textbox"))
  var other_option_textbox = Text_t(niup.GetHandle("other_option_textbox"))

  var profile_int, max_fps_int, screen_width_int, screen_height_int: int
  var custom_arm_ratio_float, calibration_range_float: float
  try:
    profile_int = profile_spin.spinvalue.parseInt
    max_fps_int = max_fps_spin.spinvalue.parseInt
    screen_width_int = screen_w_spin.spinvalue.parseInt
    screen_height_int = screen_h_spin.spinvalue.parseInt
    custom_arm_ratio_float = custom_arm_ratio_spin.value.parseFloat
    calibration_range_float = calibration_range_spin.value.parseFloat

  except ValueError:
    niup.Message("エラー" ,"値のパースに失敗した")
    return
  except:
    echo repr(getCurrentException())
    return

  var prof = new_profile(
    parse_bool(do_not_close_checkbox.value),
    parse_bool(mode_checkbox.value),
    profile_int,
    custom_home_world_textbox.value,
    other_option_textbox.value,
    parse_bool(debug_enable_checkbox.value),
    parse_bool(debug_gui_checkbox.value),
    parse_bool(debug_log_checkbox.value),
    parse_bool(debug_udon_log_checkbox.value),
    parse_bool(debug_ik_log_checkbox.value),
    parse_bool(window_enable_checkbox.value),
    parse_bool(full_screen_checkbox.value),
    max_fps_int,
    screen_width_int,
    screen_height_int,
    parse_bool(ik_enable_checkbox.value),
    parse_bool(legacy_fbt_checkbox.value),
    parse_bool(disable_shoulder_tracking_checkbox.value),
    parse_bool(freeze_tracking_on_disconnect_checkbox.value),
    custom_arm_ratio_float,
    calibration_range_float,
    parse_bool(osc_enable_checkbox.value),
    osc_in_port_textbox.value,
    osc_out_ip_textbox.value,
    osc_out_port_textbox.value
  )

  launcher.exec(prof)

proc init*() =
  var argc:cint = 0
  var argv:cstringarray = nil
  discard niup.Open(argc, addr argv)

  niup.SetGlobal("UTF8MODE", "YES")

  var bounds = load_bounds()

  var main_window = niup.Dialog(nil)
  niup.SetHandle("main_window", main_window)
  main_window.close_cb = close_proc
  main_window.title = "VRCChanger"
  main_window.rastersize(bounds.w, bounds.h)

  # main layout
  var main_container = niup.Vbox()
  main_container.expandchildren = "YES"
  main_container.ngap(0)

  var settings_scroll = niup.Scrollbox(nil)
  settings_scroll.scrollbar = "VERTICAL"

  var settings_container = custom_vbox()
  settings_container.nmargin(10, 0)

  var separator = niup.Flatseparator()
  separator.orientation = "HORIZONTAL"

  var buttons_container = niup.Hbox()
  buttons_container.ngap(4)
  buttons_container.nmargin(5, 5)

  # Settings
  var debug_frame_box = newCustomFrameVbox("Debug")
  var window_frame_box = newCustomFrameVbox("Window")
  var ik_frame_box = newCustomFrameVbox("IK")
  var osc_frame_box = newCustomFrameVbox("OSC")

  discard niup.Append(cast[PIhandle](settings_scroll), settings_container)

  discard niup.Append(cast[PIhandle](main_container), settings_scroll)
  discard niup.Append(cast[PIhandle](main_container), niup.Fill())
  discard niup.Append(cast[PIhandle](main_container), separator)
  discard niup.Append(cast[PIhandle](main_container), buttons_container)

  discard niup.Append(cast[PIhandle](main_window), main_container)

  # settings
  #   top
  var space = niup.Space()
  space.rastersize = "x5"
  space.expand = "HORIZONTAL"
  var do_not_close_checkbox = niup.Toggle("VRC起動後も開いたままにする")
  var mode_checkbox = niup.Toggle("VRMode")
  var profile_spin = newCustomSpinBox("Profile:")
  var custom_home_world_textbox = newCustomTextBox("Custom home world:")
  var other_option_textbox = newCustomTextBox("Other options:")

  # Debug
  var debug_gui_checkbox = niup.Toggle("Debug gui")
  var debug_log_checkbox = niup.Toggle("SDK log levels")
  var debug_udon_log_checkbox = niup.Toggle("Udon debug logging")
  var debug_ik_log_checkbox = niup.Toggle("IK debug logging")

  debug_frame_box.add(debug_gui_checkbox)
  debug_frame_box.add(debug_log_checkbox)
  debug_frame_box.add(debug_udon_log_checkbox)
  debug_frame_box.add(debug_ik_log_checkbox)

  # Window
  var full_screen_checkbox = niup.Toggle("Full screen")
  var max_fps_spin = newCustomSpinBox("Max FPS(Desktop only):")
  var screen_w_spin = newCustomSpinBox("Screen width:")
  var screen_h_spin = newCustomSpinBox("Screen height:")

  # 流石に上限FPSでこれ超えることないっしょ
  max_fps_spin.max = 10000

  screen_w_spin.min = 10
  screen_h_spin.min = 10
  screen_w_spin.max = 4096000
  screen_h_spin.max = 4096000
  screen_w_spin.inc = 10
  screen_h_spin.inc = 10

  window_frame_box.add(full_screen_checkbox)
  window_frame_box.add(max_fps_spin.container)
  window_frame_box.add(screen_w_spin.container)
  window_frame_box.add(screen_h_spin.container)

  # IK
  var legacy_fbt_checkbox = niup.Toggle("Legacy FBT calibrate")
  var custom_arm_ratio_spin = newCustomFloatSpinBox("Custom arm ratio:")
  var disable_shoulder_tracking_checkbox = niup.Toggle("Disable shoulder tracking")
  var calibration_range_spin = newCustomFloatSpinBox("Calibration range:")
  var freeze_tracking_on_disconnect_checkbox = niup.Toggle("Freeze tracking on disconnect")

  custom_arm_ratio_spin.max = 1
  custom_arm_ratio_spin.inc = 0.0001

  calibration_range_spin.max = 10
  calibration_range_spin.inc = 0.01

  ik_frame_box.add(legacy_fbt_checkbox)
  ik_frame_box.add(custom_arm_ratio_spin.container)
  ik_frame_box.add(disable_shoulder_tracking_checkbox)
  ik_frame_box.add(calibration_range_spin.container)
  ik_frame_box.add(freeze_tracking_on_disconnect_checkbox)

  var osc_in_port_textbox = newCustomTextBox("in Port:")
  var osc_out_ip_textbox = newCustomTextBox("out IP:")
  var osc_out_port_textbox = newCustomTextBox("out Port:")

  osc_frame_box.add(osc_in_port_textbox.container)
  osc_frame_box.add(osc_out_ip_textbox.container)
  osc_frame_box.add(osc_out_port_textbox.container)

  discard niup.Append(cast[PIhandle](settings_container), space)
  discard niup.Append(cast[PIhandle](settings_container), do_not_close_checkbox)
  discard niup.Append(cast[PIhandle](settings_container), mode_checkbox)
  discard niup.Append(cast[PIhandle](settings_container), profile_spin.container)
  discard niup.Append(cast[PIhandle](settings_container), custom_home_world_textbox.container)
  discard niup.Append(cast[PIhandle](settings_container), other_option_textbox.container)
  discard niup.Append(cast[PIhandle](settings_container), debug_frame_box.frame)
  discard niup.Append(cast[PIhandle](settings_container), window_frame_box.frame)
  discard niup.Append(cast[PIhandle](settings_container), ik_frame_box.frame)
  discard niup.Append(cast[PIhandle](settings_container), osc_frame_box.frame)

  niup.SetHandle("do_not_close_checkbox", do_not_close_checkbox)
  niup.SetHandle("mode_checkbox", mode_checkbox)
  niup.SetHandle("profile_spin", profile_spin.spin)
  niup.SetHandle("custom_home_world_textbox", custom_home_world_textbox.textbox)
  niup.SetHandle("other_option_textbox", other_option_textbox.textbox)
  niup.SetHandle("debug_enable_checkbox", debug_frame_box.toggle)
  niup.SetHandle("debug_gui_checkbox", debug_gui_checkbox)
  niup.SetHandle("debug_log_checkbox", debug_log_checkbox)
  niup.SetHandle("debug_udon_log_checkbox", debug_udon_log_checkbox)
  niup.SetHandle("debug_ik_log_checkbox", debug_ik_log_checkbox)
  niup.SetHandle("window_enable_checkbox", window_frame_box.toggle)
  niup.SetHandle("full_screen_checkbox", full_screen_checkbox)
  niup.SetHandle("max_fps_spin", max_fps_spin.spin)
  niup.SetHandle("screen_w_spin", screen_w_spin.spin)
  niup.SetHandle("screen_h_spin", screen_h_spin.spin)
  niup.SetHandle("ik_enable_checkbox", ik_frame_box.toggle)
  niup.SetHandle("legacy_fbt_checkbox", legacy_fbt_checkbox)
  niup.SetHandle("custom_arm_ratio_spin", custom_arm_ratio_spin.spin)
  niup.SetHandle("disable_shoulder_tracking_checkbox", disable_shoulder_tracking_checkbox)
  niup.SetHandle("calibration_range_spin", calibration_range_spin.spin)
  niup.SetHandle("freeze_tracking_on_disconnect_checkbox", freeze_tracking_on_disconnect_checkbox)
  niup.SetHandle("osc_enable_checkbox", osc_frame_box.toggle)
  niup.SetHandle("osc_in_port_textbox", osc_in_port_textbox.textbox)
  niup.SetHandle("osc_out_ip_textbox", osc_out_ip_textbox.textbox)
  niup.SetHandle("osc_out_port_textbox", osc_out_port_textbox.textbox)

  # buttons
  var save_button = niup.Button("Save")
  var launch_button = niup.Button("Launch")

  save_button.padding = "5x2"
  launch_button.padding = "5x2"

  discard niup.Append(cast[PIhandle](buttons_container), save_button)
  discard niup.Append(cast[PIhandle](buttons_container), launch_button)

  var profile = load_profile()
  do_not_close_checkbox.value = parse_bool(profile.do_not_close)
  mode_checkbox.value = parse_bool(profile.vr_mode)
  profile_spin.value = profile.profile
  custom_home_world_textbox.value = profile.custom_home_world
  other_option_textbox.value = profile.other_option
  debug_frame_box.enable = profile.debug
  debug_gui_checkbox.value = parse_bool(profile.debug_gui)
  debug_log_checkbox.value = parse_bool(profile.debug_log)
  debug_udon_log_checkbox.value = parse_bool(profile.debug_udon_log)
  debug_ik_log_checkbox.value = parse_bool(profile.debug_ik_log)
  window_frame_box.enable = profile.window
  full_screen_checkbox.value = parse_bool(profile.full_screen)
  max_fps_spin.value = profile.max_fps
  screen_w_spin.value = profile.screen_width
  screen_h_spin.value = profile.screen_height
  ik_frame_box.enable = profile.ik
  legacy_fbt_checkbox.value = parse_bool(profile.legacy_fbt)
  custom_arm_ratio_spin.value = profile.custom_arm_ratio
  disable_shoulder_tracking_checkbox.value = parse_bool(profile.disable_shoulder_tracking)
  freeze_tracking_on_disconnect_checkbox.value = parse_bool(profile.freeze_tracking_on_disconnect)
  calibration_range_spin.value = profile.calibration_range
  osc_frame_box.enable = profile.osc
  osc_in_port_textbox.value = profile.osc_in_port
  osc_out_ip_textbox.value = profile.osc_out_ip
  osc_out_port_textbox.value = profile.osc_out_port

  debug_frame_box.reload()
  window_frame_box.reload()
  ik_frame_box.reload()
  osc_frame_box.reload()

  proc save_button_callback(ih: PIhandle):cint {.cdecl.} =
    save_profile()

  save_button.action = save_button_callback

  proc launch_button_callback(ih: PIhandle):cint {.cdecl.} =
    launch_profile()

  launch_button.action = launch_button_callback

  discard niup.ShowXY(main_window, bounds.x.cint, bounds.y.cint)
  niupc.SetAttribute(cast[PIhandle](main_window), "USERSIZE", nil)

  discard niup.MainLoop()

  niup.Close()
