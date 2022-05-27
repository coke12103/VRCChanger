import std/json

type Bounds* = ref object
  x*: int
  y*: int
  w*: int
  h*: int

const default_w = 250
const default_h = 444

proc load_bounds*(path = "./bounds.json"): Bounds =
  try:
    var json_file = parseFile(path)

    var x = if json_file.hasKey("x"): json_file["x"].getInt else: 0
    var y = if json_file.hasKey("y"): json_file["y"].getInt else: 0
    var w = if json_file.hasKey("w"): json_file["w"].getInt else: default_w
    var h = if json_file.hasKey("h"): json_file["h"].getInt else: default_h

    result = Bounds(x: x, y: y, w: w, h: h)

  except IOError, JsonParsingError:
    return Bounds(x: 0, y: 0, w: default_w, h: default_h)
  except:
    echo repr(getCurrentException())

proc write_bounds*(x: int, y: int, w: int, h: int, path = "./bounds.json") =
  var json_str = %* { "x": x, "y": y, "w": w, "h": h }
  echo json_str
  var file = open(path, FileMode.fmWrite)
  file.write($json_str)
  file.close()
