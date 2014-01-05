#The code here connects the UI (EasyNote.html) to the 
#functionality of EasyNote.coffee and Notebook.coffee
$(document).ready ->
   easyNote = new window.EasyNote()
   #simple helper function that updates the displayed notebook page number
   #this function needs to be here because of easyNote's scope.
   setPageNumber = ->
      $('#page-number').text(easyNote.NOTEBOOK.getCurrentPageIndex())
   #set the initial page number
   setPageNumber()
   
   $('#prev-page').click ->
      easyNote.NOTEBOOK.previousPage()
      setPageNumber()
   $('#next-page').click ->
      easyNote.NOTEBOOK.nextPage()
      setPageNumber()
   
   $('#clear-canvas').click ->
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
      select 'size', @
   $('#size-small').click ->
      easyNote.setPenSize easyNote.PEN_SIZE_SMALL
      select 'size', @
   $('#size-medium').click ->
      easyNote.setPenSize easyNote.PEN_SIZE_MEDIUM
      select 'size', @
   $('#size-large').click ->
      easyNote.setPenSize easyNote.PEN_SIZE_LARGE
      select 'size', @
   $('#color-black').click ->
      easyNote.setPenColor easyNote.PEN_COLOR_DEFAULT
      select 'color', @
   $('#color-red').click ->
      easyNote.setPenColor easyNote.PEN_COLOR_RED
      select 'color', @
   $('#color-green').click ->
      easyNote.setPenColor easyNote.PEN_COLOR_GREEN
      select 'color', @
   $('#color-blue').click ->
      easyNote.setPenColor easyNote.PEN_COLOR_BLUE
      select 'color', @
   $('#paper-graph').click ->
      easyNote.graphPaper()
      select 'paper', @
   $('#paper-lined').click ->
      easyNote.linedPaper()
      select 'paper', @
   $('#paper-regular').click ->
      easyNote.regularPaper()
      select 'paper', @
   $('#print-canvas').click ->
      easyNote.printCanvas()
   $('#print-all').click ->
      easyNote.printAll()
   $('#save-canvas').click ->
      easyNote.showCanvas()
   $('#save-all').click ->
      easyNote.showAll()
      
   window.onbeforeunload = ->
      easyNote.NOTEBOOK.saveState()
      return undefined

select = (prefix, selected) ->
   $("button[id^='" + prefix + "']").each (index, element) ->
      $(element).removeClass 'selected'
      undefined
   $(selected).addClass 'selected'
