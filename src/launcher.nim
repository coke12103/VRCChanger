import profile
import std/osproc, strutils

const vrc_path = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\VRChat\\"

proc exec*(profile: Profile) =
  var options: seq[string]

  options.add("/C");
  options.add("start");
  options.add("");
  options.add((vrc_path & "VRChat.exe"));

  if not profile.vr_mode: options.add("--no-vr")
  if profile.profile != 0: options.add(("--profile=" & $(profile.profile)))

  if not profile.disable_unused_feature:
    if profile.debug: options.add("--enable-debug-gui")
    if profile.full_screen:
      options.add("-screen-fullscreen")
      options.add("1")
    else:
      options.add("-screen-fullscreen")
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

  discard startProcess("cmd", vrc_path, options)

  if not profile.do_not_close: quit(0)