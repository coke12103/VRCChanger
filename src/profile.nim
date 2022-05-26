import std/json

type Profile* = ref object
  disable_unused_feature*: bool
  do_not_close*: bool
  vr_mode*: bool
  debug*: bool
  full_screen*: bool
  profile*: int
  max_fps*: int
  screen_width*: int
  screen_height*: int
  custom_home_world*: string
  other_option*: string

proc new_profile*(
  disable_unused_feature = true,
  do_not_close = true,
  vr_mode = true,
  debug = false,
  full_screen = false,
  profile = 0,
  max_fps = 90,
  screen_width = 1600,
  screen_height = 900,
  custom_home_world = "",
  other_option = ""
): Profile =
  return Profile(
    disable_unused_feature: disable_unused_feature,
    do_not_close: do_not_close,
    vr_mode: vr_mode,
    debug: debug,
    full_screen: full_screen,
    profile: profile,
    max_fps: max_fps,
    screen_width: screen_width,
    screen_height: screen_height,
    custom_home_world: custom_home_world,
    other_option: other_option
  )

proc load_profile*(path = "./profile.json"): Profile =
  try:
    var json_file = parseFile(path)

    if not (
      json_file.hasKey("disable_unused_feature") and
      json_file.hasKey("do_not_close") and
      json_file.hasKey("vr_mode") and
      json_file.hasKey("debug") and
      json_file.hasKey("full_screen") and
      json_file.hasKey("profile") and
      json_file.hasKey("max_fps") and
      json_file.hasKey("screen_width") and
      json_file.hasKey("screen_height")
    ): return new_profile()

    var custom_home_world = if json_file.hasKey("custom_home_world"): json_file["custom_home_world"].getStr else: ""
    var other_option = if json_file.hasKey("other_option"): json_file["other_option"].getStr else: ""

    result = new_profile(
      json_file["disable_unused_feature"].getBool,
      json_file["do_not_close"].getBool,
      json_file["vr_mode"].getBool,
      json_file["debug"].getBool,
      json_file["full_screen"].getBool,
      json_file["profile"].getInt,
      json_file["max_fps"].getInt,
      json_file["screen_width"].getInt,
      json_file["screen_height"].getInt,
      custom_home_world,
      other_option
    )

  except IOError, JsonParsingError:
    return new_profile()
  except:
    echo repr(getCurrentException())

proc write_profile*(profile: Profile, path = "./profile.json") =
  var json_str = %* {
    "disable_unused_feature": profile.disable_unused_feature,
    "do_not_close": profile.do_not_close,
    "vr_mode": profile.vr_mode,
    "debug": profile.debug,
    "full_screen": profile.full_screen,
    "profile": profile.profile,
    "max_fps": profile.max_fps,
    "screen_width": profile.screen_width,
    "screen_height": profile.screen_height,
    "custom_home_world": profile.custom_home_world,
    "other_option": profile.other_option
  }

  var file = open(path, FileMode.fmWrite)
  file.write($json_str)
  file.close()
