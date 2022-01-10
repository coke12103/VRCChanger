import nigui, nigui/msgbox, strutils
import bounds, profile, launcher

const label_width = 170

proc init*() =
  app.init()

  # init window
  var bounds = load_bounds()

  var win = newWindow("VRCChanger")

  win.width = 250.scaleToDpi
  win.height = 420.scaleToDpi
  win.x = bounds.x
  win.y = bounds.y

  win.onCloseClick = proc(event: CloseClickEvent) =
    write_bounds(win.x, win.y)
    echo "exit"
    win.dispose()

  # layout
  var main_layout = newLayoutContainer(Layout_Vertical)
  main_layout.padding = 4

  var setting_area = newLayoutContainer(Layout_Vertical)
  setting_area.padding = 2

  var button_area = newLayoutContainer(Layout_Horizontal)
  button_area.padding = 2

  main_layout.add(setting_area)
  main_layout.add(button_area)

  win.add(main_layout)

  # settings
  var disable_unused_feature_container = newLayoutContainer(Layout_Horizontal)
  var disable_unused_feature_label = newLabel("[*]の付いた項目を無効化")
  disable_unused_feature_label.minWidth = label_width
  disable_unused_feature_label.heightMode = HeightMode_Fill
  var disable_unused_feature_checkbox = newCheckbox()
  disable_unused_feature_container.add(disable_unused_feature_label)
  disable_unused_feature_container.add(disable_unused_feature_checkbox)

  var do_not_close_container = newLayoutContainer(Layout_Horizontal)
  var do_not_close_label = newLabel("VRC起動後も開いたままにする")
  do_not_close_label.minWidth = label_width
  do_not_close_label.heightMode = HeightMode_Fill
  var do_not_close_checkbox = newCheckbox()
  do_not_close_container.add(do_not_close_label)
  do_not_close_container.add(do_not_close_checkbox)

  var mode_container = newLayoutContainer(Layout_Horizontal)
  var mode_label = newLabel("VRMode")
  mode_label.minWidth = label_width
  mode_label.heightMode = HeightMode_Fill
  var mode_checkbox = newCheckbox()
  mode_container.add(mode_label)
  mode_container.add(mode_checkbox)

  var debug_container = newLayoutContainer(Layout_Horizontal)
  var debug_label = newLabel("Debug*")
  debug_label.minWidth = label_width
  debug_label.heightMode = HeightMode_Fill
  var debug_checkbox = newCheckbox()
  debug_container.add(debug_label)
  debug_container.add(debug_checkbox)

  var full_screen_container = newLayoutContainer(Layout_Horizontal)
  var full_screen_label = newLabel("FullScreen*")
  full_screen_label.minWidth = label_width
  full_screen_label.heightMode = HeightMode_Fill
  var full_screen_checkbox = newCheckbox()
  full_screen_container.add(full_screen_label)
  full_screen_container.add(full_screen_checkbox)
  # MEMO: Use Legacy fbt

  var profile_container = newLayoutContainer(Layout_Horizontal)
  var profile_label = newLabel("Profile")
  profile_label.minWidth = label_width
  profile_label.heightMode = HeightMode_Fill
  var profile_box = newTextBox()
  profile_container.add(profile_label)
  profile_container.add(profile_box)

  var max_fps_container = newLayoutContainer(Layout_Horizontal)
  var max_fps_label = newLabel("Max FPS*(only Desktop)")
  max_fps_label.minWidth = label_width
  max_fps_label.heightMode = HeightMode_Fill
  var max_fps_box = newTextBox()
  max_fps_container.add(max_fps_label)
  max_fps_container.add(max_fps_box)

  var screen_w_container = newLayoutContainer(Layout_Horizontal)
  var screen_w_label = newLabel("Screen Width*")
  screen_w_label.minWidth = label_width
  screen_w_label.heightMode = HeightMode_Fill
  var screen_w_box = newTextBox()
  screen_w_container.add(screen_w_label)
  screen_w_container.add(screen_w_box)

  var screen_h_container = newLayoutContainer(Layout_Horizontal)
  var screen_h_label = newLabel("Screen Height*")
  screen_h_label.minWidth = label_width
  screen_h_label.heightMode = HeightMode_Fill
  var screen_h_box = newTextBox()
  screen_h_container.add(screen_h_label)
  screen_h_container.add(screen_h_box)

  var other_option_container = newLayoutContainer(Layout_Horizontal)
  var other_option_label = newLabel("Other option")
  other_option_label.minWidth = label_width
  other_option_label.heightMode = HeightMode_Fill
  var other_option_box = newTextBox()
  other_option_container.add(other_option_label)
  other_option_container.add(other_option_box)

  setting_area.add(disable_unused_feature_container)
  setting_area.add(do_not_close_container)
  setting_area.add(mode_container)
  setting_area.add(debug_container)
  setting_area.add(full_screen_container)
  setting_area.add(profile_container)
  setting_area.add(max_fps_container)
  setting_area.add(screen_w_container)
  setting_area.add(screen_h_container)
  setting_area.add(other_option_container)

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

    var profile = Profile(
      disable_unused_feature: disable_unused_feature_checkbox.checked,
      do_not_close: do_not_close_checkbox.checked,
      vr_mode: mode_checkbox.checked,
      debug: debug_checkbox.checked,
      full_screen: full_screen_checkbox.checked,
      profile: profile_int,
      max_fps: max_fps_int,
      screen_width: screen_width_int,
      screen_height: screen_height_int,
      other_option: other_option_box.text
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

    var profile = Profile(
      disable_unused_feature: disable_unused_feature_checkbox.checked,
      do_not_close: do_not_close_checkbox.checked,
      vr_mode: mode_checkbox.checked,
      debug: debug_checkbox.checked,
      full_screen: full_screen_checkbox.checked,
      profile: profile_int,
      max_fps: max_fps_int,
      screen_width: screen_width_int,
      screen_height: screen_height_int,
      other_option: other_option_box.text
    )

    launcher.exec(profile)

  win.show()
  app.run()

