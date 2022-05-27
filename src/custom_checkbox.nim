import oolib, nigui

const label_width = 170

class pub CustomCheckbox:
  var
    container*: LayoutContainer
    label: Label
    checkbox: Checkbox

  proc `new`(label_text: string) =
    self.container = newLayoutContainer(Layout_Horizontal)
    self.label = newLabel(label_text)
    self.checkbox = newCheckbox()

    self.label.minWidth = label_width
    self.label.heightMode = HeightMode_Fill

    self.container.add(self.label)
    self.container.add(self.checkbox)

  proc checked*: bool =
    return self.checkbox.checked

  proc `checked=`*(checked: bool) =
    self.checkbox.checked = checked

  proc `onToggle=`*(callback: ToggleProc) =
    self.checkbox.onToggle = callback
