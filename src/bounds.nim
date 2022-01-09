import std/json

type Bounds* = ref object
  x*: int
  y*: int

proc load_bounds*(path = "./bounds.json"): Bounds =
  try:
    var json_file = parseFile(path)

    if not (
      json_file.hasKey("x") and
      json_file.hasKey("y")
    ): return Bounds(x: 0, y: 0)

    result = Bounds(x: json_file["x"].getInt, y: json_file["y"].getInt)

  except IOError, JsonParsingError:
    return Bounds(x: 0, y: 0)
  except:
    echo repr(getCurrentException())

proc write_bounds*(x: int, y: int, path = "./bounds.json") =
  var json_str = %* { "x": x, "y": y }
  var file = open(path, FileMode.fmWrite)
  file.write($json_str)
  file.close()
