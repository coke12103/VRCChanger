import std/json

type Profile* = ref object
  do_not_close*: bool
  vr_mode*: bool
  profile*: int
  custom_home_world*: string
  other_option*: string
  # Debug
  debug*: bool
  debug_gui*: bool
  debug_log*: bool
  debug_udon_log*: bool
  debug_ik_log*: bool
  # Window
  window*: bool
  full_screen*: bool
  max_fps*: int
  screen_width*: int
  screen_height*: int
  # IK
  ik*: bool
  legacy_fbt*: bool
  disable_shoulder_tracking*: bool
  freeze_tracking_on_disconnect*: bool
  custom_arm_ratio*: float
  calibration_range*: float
  # OSC
  osc*: bool
  osc_in_port*: string
  osc_out_ip*: string
  osc_out_port*: string

proc new_profile*(
  do_not_close = true,
  vr_mode = true,
  profile = 0,
  custom_home_world = "",
  other_option = "",
  debug = false,
  debug_gui = false,
  debug_log = false,
  debug_udon_log = false,
  debug_ik_log = false,
  window = false,
  full_screen = false,
  max_fps = 90,
  screen_width = 1600,
  screen_height = 900,
  ik = false,
  legacy_fbt = false,
  disable_shoulder_tracking = false,
  freeze_tracking_on_disconnect = false,
  custom_arm_ratio = 0.4537,
  calibration_range = 0.6,
  osc = false,
  osc_in_port = "9000",
  osc_out_ip = "127.0.0.1",
  osc_out_port = "9001"
): Profile =
  return Profile(
    do_not_close: do_not_close,
    vr_mode: vr_mode,
    profile: profile,
    custom_home_world: custom_home_world,
    other_option: other_option,
    debug: debug,
    debug_gui: debug_gui,
    debug_log: debug_log,
    debug_udon_log: debug_udon_log,
    debug_ik_log: debug_ik_log,
    window: window,
    full_screen: full_screen,
    max_fps: max_fps,
    screen_width: screen_width,
    screen_height: screen_height,
    ik: ik,
    legacy_fbt: legacy_fbt,
    disable_shoulder_tracking: disable_shoulder_tracking,
    freeze_tracking_on_disconnect: freeze_tracking_on_disconnect,
    custom_arm_ratio: custom_arm_ratio,
    calibration_range: calibration_range,
    osc: osc,
    osc_in_port: osc_in_port,
    osc_out_ip: osc_out_ip,
    osc_out_port: osc_out_port
  )

proc load_profile*(path = "./profile.json"): Profile =
  try:
    var json_file = parseFile(path)

    var do_not_close = if json_file.hasKey("do_not_close"): json_file["do_not_close"].getBool else: true
    var vr_mode = if json_file.hasKey("vr_mode"): json_file["vr_mode"].getBool else: true
    var profile = if json_file.hasKey("profile"): json_file["profile"].getInt else: 0
    var custom_home_world = if json_file.hasKey("custom_home_world"): json_file["custom_home_world"].getStr else: ""
    var other_option = if json_file.hasKey("other_option"): json_file["other_option"].getStr else: ""
    var debug = if json_file.hasKey("debug"): json_file["debug"].getBool else: false
    var debug_gui = if json_file.hasKey("debug_gui"): json_file["debug_gui"].getBool else: false
    var debug_log = if json_file.hasKey("debug_log"): json_file["debug_log"].getBool else: false
    var debug_udon_log = if json_file.hasKey("debug_udon_log"): json_file["debug_udon_log"].getBool else: false
    var debug_ik_log = if json_file.hasKey("debug_ik_log"): json_file["debug_ik_log"].getBool else: false
    var window = if json_file.hasKey("window"): json_file["window"].getBool else: false
    var full_screen = if json_file.hasKey("full_screen"): json_file["full_screen"].getBool else: false
    var max_fps = if json_file.hasKey("max_fps"): json_file["max_fps"].getInt else: 90
    var screen_width = if json_file.hasKey("screen_width"): json_file["screen_width"].getInt else: 1600
    var screen_height = if json_file.hasKey("screen_height"): json_file["screen_height"].getInt else: 900
    var ik = if json_file.hasKey("ik"): json_file["ik"].getBool else: false
    var legacy_fbt = if json_file.hasKey("legacy_fbt"): json_file["legacy_fbt"].getBool else: false
    var disable_shoulder_tracking = if json_file.hasKey("disable_shoulder_tracking"): json_file["disable_shoulder_tracking"].getBool else: false
    var freeze_tracking_on_disconnect = if json_file.hasKey("freeze_tracking_on_disconnect"): json_file["freeze_tracking_on_disconnect"].getBool else: false
    var custom_arm_ratio = if json_file.hasKey("custom_arm_ratio"): json_file["custom_arm_ratio"].getFloat else: 0.4537
    var calibration_range = if json_file.hasKey("calibration_range"): json_file["calibration_range"].getFloat else: 0.6
    var osc = if json_file.hasKey("osc"): json_file["osc"].getBool else: false
    var osc_in_port = if json_file.hasKey("osc_in_port"): json_file["osc_in_port"].getStr else: "9000"
    var osc_out_ip = if json_file.hasKey("osc_out_ip"): json_file["osc_out_ip"].getStr else: "127.0.0.1"
    var osc_out_port = if json_file.hasKey("osc_out_port"): json_file["osc_out_port"].getStr else: "9001"

    result = new_profile(
      do_not_close,
      vr_mode,
      profile,
      custom_home_world,
      other_option,
      debug,
      debug_gui,
      debug_log,
      debug_udon_log,
      debug_ik_log,
      window,
      full_screen,
      max_fps,
      screen_width,
      screen_height,
      ik,
      legacy_fbt,
      disable_shoulder_tracking,
      freeze_tracking_on_disconnect,
      custom_arm_ratio,
      calibration_range,
      osc,
      osc_in_port,
      osc_out_ip,
      osc_out_port
    )

  except IOError, JsonParsingError:
    return new_profile()
  except:
    echo repr(getCurrentException())

proc write_profile*(profile: Profile, path = "./profile.json") =
  var json_str = %* {
    "do_not_close": profile.do_not_close,
    "vr_mode": profile.vr_mode,
    "profile": profile.profile,
    "custom_home_world": profile.custom_home_world,
    "other_option": profile.other_option,
    "debug": profile.debug,
    "debug_gui": profile.debug_gui,
    "debug_log": profile.debug_log,
    "debug_udon_log": profile.debug_udon_log,
    "debug_ik_log": profile.debug_ik_log,
    "window": profile.window,
    "full_screen": profile.full_screen,
    "max_fps": profile.max_fps,
    "screen_width": profile.screen_width,
    "screen_height": profile.screen_height,
    "ik": profile.ik,
    "legacy_fbt": profile.legacy_fbt,
    "disable_shoulder_tracking": profile.disable_shoulder_tracking,
    "freeze_tracking_on_disconnect": profile.freeze_tracking_on_disconnect,
    "custom_arm_ratio": profile.custom_arm_ratio,
    "calibration_range": profile.calibration_range,
    "osc": profile.osc,
    "osc_in_port": profile.osc_in_port,
    "osc_out_ip": profile.osc_out_ip,
    "osc_out_port": profile.osc_out_port
  }

  var file = open(path, FileMode.fmWrite)
  file.write($json_str)
  file.close()
