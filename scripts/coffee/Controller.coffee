#The code here connects the UI (EasyNote.html) to the 
#functionality of EasyNote.coffee
$(document).ready ->
   easyNote = new window.EasyNote()
   $('#pen-button').click ->
      easyNote.activatePen()
   $('#eraser-button').click ->
      easyNote.activateEraser()