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
  var main_layout = newLayoutContainer(Layout_Vertical)
  main_layout.padding = 4

  var setting_area = newLayoutContainer(Layout_Vertical)
  setting_area.padding = 2
  setting_area.spacing = 1

  var button_area = newLayoutContainer(Layout_Horizontal)
  button_area.padding = 2

  main_layout.add(setting_area)
  main_layout.add(button_area)

  win.add(main_layout)

  # settings
  var disable_unused_feature_checkbox = newCustomCheckbox("[*]の付いた項目を無効化")
  var do_not_close_checkbox = newCustomCheckbox("VRC起動後も開いたままにする")
  var mode_checkbox = newCustomCheckbox("VRMode")
  var debug_checkbox = newCustomCheckbox("Debug*")
  var full_screen_checkbox = newCustomCheckbox("FullScreen*")
  # MEMO: Use Legacy fbt

  var profile_box = newCustomTextBox("Profile")
  var max_fps_box = newCustomTextBox("Max FPS*(only Desktop)")
  var screen_w_box = newCustomTextBox("Screen Width*")
  var screen_h_box = newCustomTextBox("Screen Height*")
  var custom_home_world_box = newCustomTextBox("Custom home world")
  var other_option_box = newCustomTextBox("Other option")

  setting_area.add(disable_unused_feature_checkbox.container)
  setting_area.add(do_not_close_checkbox.container)
  setting_area.add(mode_checkbox.container)
  setting_area.add(debug_checkbox.container)
  setting_area.add(full_screen_checkbox.container)
  setting_area.add(profile_box.container)
  setting_area.add(max_fps_box.container)
  setting_area.add(screen_w_box.container)
  setting_area.add(screen_h_box.container)
  setting_area.add(custom_home_world_box.container)
  setting_area.add(other_option_box.container)

  # buttons
  var save_button = newButton("Save")
  var launch_button = newButton("Launch")

  button_area.add(save_button)
  button_area.add(launch_button)

  # profile
  var profile = load_profile()

  disable_unused_feature_checkbox.checked = profile.disable_unused_feature
  do_not_close_checkbox.checked = profile.do_not_close
  mode_checkbox.checked = profile.vr_mode
  debug_checkbox.checked = profile.debug
  full_screen_checkbox.checked = profile.full_screen
  profile_box.text = $(profile.profile)
  max_fps_box.text = $(profile.max_fps)
  screen_w_box.text = $(profile.screen_width)
  screen_h_box.text = $(profile.screen_height)
  custom_home_world_box.text = profile.custom_home_world
  other_option_box.text = profile.other_option

  # events
  save_button.onClick = proc(event: ClickEvent) =
    var profile_int, max_fps_int, screen_width_int, screen_height_int: int
    try:
      profile_int = profile_box.text.parseInt
      max_fps_int = max_fps_box.text.parseInt
      screen_width_int = screen_w_box.text.parseInt
      screen_height_int = screen_h_box.text.parseInt
    except ValueError:
      # 多分2バイト文字だから長さ正しく取れてない
      win.msgBox("テキストボックスにテキストを入れないで              ")
      return
    except:
      echo repr(getCurrentException())
      return

    var profile = new_profile(
      disable_unused_feature_checkbox.checked,
      do_not_close_checkbox.checked,
      mode_checkbox.checked,
      debug_checkbox.checked,
      full_screen_checkbox.checked,
      profile_int,
      max_fps_int,
      screen_width_int,
      screen_height_int,
      custom_home_world_box.text,
      other_option_box.text
    )

    write_profile(profile)
    win.msgBox("Save done!")

  launch_button.onClick = proc(event: ClickEvent) =
    var profile_int, max_fps_int, screen_width_int, screen_height_int: int
    try:
      profile_int = profile_box.text.parseInt
      max_fps_int = max_fps_box.text.parseInt
      screen_width_int = screen_w_box.text.parseInt
      screen_height_int = screen_h_box.text.parseInt
    except ValueError:
      # 多分2バイト文字だから長さ正しく取れてない
      win.msgBox("テキストボックスにテキストを入れないで              ")
      return
    except:
      echo repr(getCurrentException())
      return

    var profile = new_profile(
      disable_unused_feature_checkbox.checked,
      do_not_close_checkbox.checked,
      mode_checkbox.checked,
      debug_checkbox.checked,
      full_screen_checkbox.checked,
      profile_int,
      max_fps_int,
      screen_width_int,
      screen_height_int,
      custom_home_world_box.text,
      other_option_box.text
    )

    launcher.exec(profile)

  win.show()
  app.run()

