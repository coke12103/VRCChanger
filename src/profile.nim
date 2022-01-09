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
  other_option*: string

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
    ): return Profile(
      disable_unused_feature: true,
      do_not_close: true,
      vr_mode: true,
      debug: false,
      full_screen: false,
      profile: 0,
      max_fps: 90,
      screen_width: 1600,
      screen_height: 900,
      other_option: ""
    )

    var other_option = if json_file.hasKey("other_option"): json_file["other_option"].getStr else: ""

    result = Profile(
      disable_unused_feature: json_file["disable_unused_feature"].getBool,
      do_not_close: json_file["do_not_close"].getBool,
      vr_mode: json_file["vr_mode"].getBool,
      debug: json_file["debug"].getBool,
      full_screen: json_file["full_screen"].getBool,
      profile: json_file["profile"].getInt,
      max_fps: json_file["max_fps"].getInt,
      screen_width: json_file["screen_width"].getInt,
      screen_height: json_file["screen_height"].getInt,
      other_option: other_option
    )

  except IOError, JsonParsingError:
    return Profile(
      disable_unused_feature: true,
      do_not_close: true,
      vr_mode: true,
      debug: false,
      full_screen: false,
      profile: 0,
      max_fps: 90,
      screen_width: 1600,
      screen_height: 900,
      other_option: ""
    )
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
    "other_option": profile.other_option
  }

  var file = open(path, FileMode.fmWrite)
  file.write($json_str)
  file.close()
