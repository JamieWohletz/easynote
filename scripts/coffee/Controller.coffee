#The code here connects the UI (EasyNote.html) to the 
#functionality of EasyNote.coffee
$(document).ready ->
   easyNote = new window.EasyNote()
   $('#clear-canvas').click ->
      console.log 'derp'
      confirmed = window.confirm 'Erase all drawings?'
      if confirmed
         easyNote.clearAll()
   $('#pen-button').click ->
      $('#pen-button').addClass 'selected'
      $('#eraser-button').removeClass 'selected'
      easyNote.activatePen()
   $('#eraser-button').click ->
      $('#eraser-button').addClass 'selected'
      $('#pen-button').removeClass 'selected'
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
   $('#save-canvas').click ->
      #showSaveHelp()
      easyNote.showCanvas()
   $('#save-all').click ->
      #showSaveHelp()
      easyNote.showAll()
      
showSaveHelp = ->
   alert "Right click the image that appears and click \"Save image as...\" to save your picture."