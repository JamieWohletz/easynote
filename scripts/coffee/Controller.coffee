#The code here connects the UI (EasyNote.html) to the 
#functionality of EasyNote.coffee
$(document).ready ->
   easyNote = new window.EasyNote()
   $('#clear-canvas').click ->
      easyNote.clearAll()
   $('#pen-button').click ->
      easyNote.activatePen()
   $('#eraser-button').click ->
      easyNote.activateEraser()
   $('#size-tiny').click ->
      easyNote.setPenSize easyNote.PEN_SIZE_TINY
   $('#size-small').click ->
      easyNote.setPenSize easyNote.PEN_SIZE_SMALL
   $('#size-medium').click ->
      easyNote.setPenSize easyNote.PEN_SIZE_MEDIUM
   $('#size-large').click ->
      easyNote.setPenSize easyNote.PEN_SIZE_LARGE
   $('#color-black').click ->
      easyNote.setPenColor easyNote.PEN_COLOR_DEFAULT
   $('#color-red').click ->
      easyNote.setPenColor easyNote.PEN_COLOR_RED
   $('#color-green').click ->
      easyNote.setPenColor easyNote.PEN_COLOR_GREEN
   $('#color-blue').click ->
      easyNote.setPenColor easyNote.PEN_COLOR_BLUE
   $('#paper-graph').click ->
      easyNote.graphPaper()
   $('#paper-lined').click ->
      easyNote.linedPaper()
   $('#paper-regular').click ->
      easyNote.regularPaper()
   $('#print-canvas').click ->
      easyNote.printCanvas()
   $('#print-all').click ->
      easyNote.printAll()