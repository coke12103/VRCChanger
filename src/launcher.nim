import profile
import std/osproc, strutils

const vrc_path = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\VRChat\\"

proc escape_cmd_str(str: string):string

proc exec*(profile: Profile) =
  # そのまま叩くと何故かワールドに入れずにフリーズするのでcmdに叩かせる
  var options = @["/C", "start", "", (vrc_path & "VRChat.exe")]

  if not profile.vr_mode: options.add("--no-vr")
  if profile.profile != 0: options.add(("--profile=" & $(profile.profile)))

  if not profile.disable_unused_feature:
    if profile.debug: options.add("--enable-debug-gui")

    options.add("-screen-fullscreen")
    if profile.full_screen:
      options.add("1")
    else:
      options.add("0")

    if not profile.vr_mode: options.add(("--fps=" & $(profile.max_fps)))
    options.add("-screen-width")
    options.add($(profile.screen_width))
    options.add("-screen-height")
    options.add($(profile.screen_height))
  else:
    options.add("-screen-fullscreen")
    options.add("0")

  if profile.other_option.len > 1:
    for o in profile.other_option.split(" "):
      options.add(o)

  if profile.custom_home_world.len > 1:
    options.add(escape_cmd_str(profile.custom_home_world))

  discard startProcess("cmd", vrc_path, options)

  if not profile.do_not_close: quit(0)

proc escape_cmd_str(str: string):string =
  # カスカスカスカスカスカス
  return str.replace("^", "^^").replace("&", "^&").replace("(", "^(").replace(")", "^)").replace("<", "^<").replace(">", "^>")

