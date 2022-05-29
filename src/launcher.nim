import profile
import std/osproc, strutils

const vrc_path = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\VRChat\\"

proc escape_cmd_str(str: string):string

proc exec*(profile: Profile) =
  # そのまま叩くと何故かワールドに入れずにフリーズするのでcmdに叩かせる
  var options = @["/C", "start", "", (vrc_path & "VRChat.exe")]

  if not profile.vr_mode: options.add("--no-vr")
  if profile.profile != 0: options.add(("--profile=" & $(profile.profile)))

  if profile.debug:
    if profile.debug_gui: options.add("--enable-debug-gui")
    if profile.debug_log: options.add("--enable-sdk-log-levels")
    if profile.debug_udon_log: options.add("--enable-udon-debug-logging")
    if profile.debug_ik_log: options.add("--enable-ik-debug-logging")

  if profile.window:
    options.add("-screen-fullscreen")
    if profile.full_screen: options.add("1")
    else: options.add("0")
    if not profile.vr_mode: options.add(("--fps=" & $(profile.max_fps)))
    options.add("-screen-width")
    options.add($(profile.screen_width))
    options.add("-screen-height")
    options.add($(profile.screen_height))
  else:
    options.add("-screen-fullscreen")
    options.add("0")

  if profile.ik:
    if profile.legacy_fbt: options.add("--legacy-fbt-calibrate")
    if profile.disable_shoulder_tracking: options.add("--disable-shoulder-tracking")
    if profile.freeze_tracking_on_disconnect: options.add("--freeze-tracking-on-disconnect")
    if profile.custom_arm_ratio != 0.4537: options.add(("--custom-arm-ratio=^\"" & $(profile.custom_arm_ratio) & "^\""))
    if profile.calibration_range != 0.6: options.add(("--calibration-range=^\"" & $(profile.calibration_range) & "^\""))

  if profile.osc:
    options.add(("osc=" & profile.osc_in_port & ":" & profile.osc_out_ip & ":" & profile.osc_out_port))

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

