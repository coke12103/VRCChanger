import oolib, niup, nuuid, strutils, math

const text_label_width = "130x"
const spin_min_size = "60x"

proc custom_vbox*(): Vbox_t =
  var vbox = niup.Vbox()
  vbox.ngap(6)
  vbox.expandchildren = "YES"

  return vbox


class pub CustomSpinBox:
  var
    container*: Hbox_t
    label: Label_t
    spin*: Text_t

  proc `new`(label_text: string) =
    self.container = niup.Hbox()
    self.label = niup.Label(label_text)
    self.spin = niup.Text()

    self.container.ngap(5)
    self.container.alignment("ACENTER")

    self.spin.mask = IUP_MASK_INT
    self.spin.spin = "YES"
    self.spin.rastersize = spin_min_size

    discard niup.Append(cast[PIhandle](self.container), self.label)
    discard niup.Append(cast[PIhandle](self.container), niup.Fill())
    discard niup.Append(cast[PIhandle](self.container), self.spin)

  proc `min=`*(value: int) =
    # Default: 0
    self.spin.spinmin = value

  proc `max=`*(value: int) =
    # Default: 100
    self.spin.spinmax = value

  proc `inc=`*(value: int) =
    # Default: 1
    self.spin.spininc = value

  proc `value=`*(value: int) =
    self.spin.spinvalue = $value

  proc `value`*(): int =
    return (self.spin.spinvalue.parseInt)


class pub CustomFloatSpinBox:
  var
    container*: Hbox_t
    label: Label_t
    spin*: Text_t

  proc `new`(label_text: string) =
    self.container = niup.Hbox()
    self.label = niup.Label(label_text)
    self.spin = niup.Text()
    var inc_value = 0.1
    var max_value = 100
    var min_value = 0

    self.container.ngap(5)
    self.container.alignment("ACENTER")

    self.spin.mask = IUP_MASK_FLOAT
    self.spin.spin = "YES"
    self.spin.rastersize = spin_min_size
    self.spin.value = $(min_value)
    # Spinの実装を利用するが整数しか対応してないので上手いことやる
    self.spin.spinauto = "NO"
    self.spin.spinmin = -1
    self.spin.spinmax = 1
    self.spin.spinvalue = 0
    self.spin.spininc = 1

    niup.SetFloat(cast[PIhandle](self.spin), "_INC_VALUE", inc_value.cfloat)
    niup.SetFloat(cast[PIhandle](self.spin), "_MIN_VALUE", min_value.cfloat)
    niup.SetFloat(cast[PIhandle](self.spin), "_MAX_VALUE", max_value.cfloat)

    proc spin_callback(ih: PIhandle, pos: cint): cint {.cdecl.} =
      # 変更ないならreturn
      if pos == 0: return IUP_IGNORE
      var text = Text_t(ih)

      const max_dig = 1000000
      var inc_value = niup.GetFloat(ih, "_INC_VALUE")
      var max_value = niup.GetFloat(ih, "_MAX_VALUE")
      var min_value = niup.GetFloat(ih, "_MIN_VALUE")

      var is_inc = (pos > 0)
      var float_value = if not text.value.isEmptyOrWhiteSpace: text.value.parseFloat else: min_value

      var round_float = round(float_value * max_dig)
      var round_inc = round(inc_value * max_dig)

      if is_inc: float_value = (round_float.toInt + round_inc.toInt).toFloat / max_dig
      else: float_value = (round_float.toInt - round_inc.toInt).toFloat / max_dig


      if float_value > max_value: float_value = max_value
      elif float_value < min_value: float_value = min_value

      text.value = $float_value

      # 後始末
      text.spinvalue = 0
      return IUP_IGNORE

    proc action_callback(ih: PIhandle, c: cint, new_str_c : cstring): cint {.cdecl.} =
      var text = Text_t(ih)

      var is_valid = true

      var max_value = niup.GetFloat(ih, "_MAX_VALUE")
      var min_value = niup.GetFloat(ih, "_MIN_VALUE")

      var new_str = $new_str_c

      var float_value = min_value

      if not new_str.isEmptyOrWhiteSpace:
        float_value = new_str.parseFloat
      else:
        is_valid = false

      if float_value > max_value:
        is_valid = false
        float_value = max_value
      elif float_value < min_value:
        is_valid = false
        float_value = min_value

      if is_valid:
        return IUP_DEFAULT
      else:
        text.value = $float_value
        return IUP_IGNORE

    self.spin.spin_cb = spin_callback
    self.spin.action = action_callback

    discard niup.Append(cast[PIhandle](self.container), self.label)
    discard niup.Append(cast[PIhandle](self.container), niup.Fill())
    discard niup.Append(cast[PIhandle](self.container), self.spin)

  proc `min=`*(value: float) =
    # Default: 0
    niup.SetFloat(cast[PIhandle](self.spin), "_MIN_VALUE", value.cfloat)

  proc `max=`*(value: float) =
    # Default: 100
    niup.SetFloat(cast[PIhandle](self.spin), "_MAX_VALUE", value.cfloat)

  proc `inc=`*(value: float) =
    # Default: 0.1
    niup.SetFloat(cast[PIhandle](self.spin), "_INC_VALUE", value.cfloat)

  proc `value=`*(value: float) =
    self.spin.value = $value

  proc `value`*(): float =
    return (self.spin.value.parseFloat)

class pub CustomTextBox:
  var
    container*: Hbox_t
    label: Label_t
    textbox*: Text_t

  proc `new`(label_text: string) =
    self.container = niup.Hbox()
    self.label = niup.Label(label_text)
    self.textbox = niup.Text()

    self.container.ngap(0)
    self.container.alignment("ACENTER")

    self.label.rastersize(text_label_width)

    self.textbox.expand = "HORIZONTAL"

    discard niup.Append(cast[PIhandle](self.container), self.label)
    discard niup.Append(cast[PIhandle](self.container), self.textbox)

  proc `value=`*(value: string) =
    self.textbox.value = value

  proc `value`*(): string =
    result = $(self.textbox.value)


proc toggle_proc(ih: PIhandle, state: cint): cint {.cdecl.} =
  var sub_container = Vbox_t(GetHandle(niup.GetAttribute(ih, "_sub_container_id")))
  var state_str = if state != 0: "YES" else: "NO"
  var rev_state_str = if state_str == "YES": "NO" else: "YES"
  sub_container.visible = state_str
  sub_container.floating = rev_state_str
  niup.Refresh(sub_container)

class pub CustomFrameVbox:
  # Layout
  #
  # Frame
  #   Container
  #     Toggle(Enable/Disable SubContainer)
  #     SubContainer
  #       AnyItems...
  var
    frame*: Frame_t
    container: Vbox_t
    toggle*: Toggle_t
    sub_container: Vbox_t
    sub_container_id: string

  proc `new`(frame_text: string) =
    self.frame = niup.Frame(nil)
    self.container = custom_vbox()
    self.toggle = niup.Toggle("Enable")
    self.sub_container = custom_vbox()
    self.sub_container_id = generateUUID()

    self.frame.title = frame_text

    self.container.nmargin(5, 5)

    niup.SetStrAttribute(cast[PIhandle](self.toggle), "_sub_container_id", self.sub_container_id)

    self.toggle.action = toggle_proc

    niup.SetHandle(self.sub_container_id, self.sub_container)

    self.sub_container.nmargin("5x")

    discard niup.Append(cast[PIhandle](self.frame), self.container)
    discard niup.Append(cast[PIhandle](self.container), self.toggle)
    discard niup.Append(cast[PIhandle](self.container), self.sub_container)

    # Check入ってないと状態が合わないので合わせる
    self.toggle.value = "ON"

  proc add*(child: IUPhandle_t) =
    discard niup.Append(cast[PIhandle](self.sub_container), child)

  proc `enable=`*(value: bool) =
    self.toggle.value = if value: "ON" else: "OFF"

  proc `enable`*(): bool =
    result = (self.toggle.value == "ON")

  proc reload*() =
    var state = if self.toggle.value == "ON": 1 else: 0
    discard toggle_proc(cast[PIhandle](self.toggle), state.cint)
