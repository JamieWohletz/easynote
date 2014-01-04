class window.EasyNote
   #The width is either 50% the window width OR 900 pixels. It will never go below 900 pixels.
   WIDTH: Math.max (window.innerWidth / 100) * 50, 900
   #The height is set in the constructor and is proportional 
   #to the window width; this ratio comes from 
   #standard letter paper dimensions (8.5 x 11). 
   HEIGHT: null
   #The distance between rule lines (lined paper, graph paper)
   LINE_SPACE: 20
   #Pen constants
   PEN_SIZE_TINY: 2
   PEN_SIZE_SMALL: 5
   PEN_SIZE_MEDIUM: 10
   PEN_SIZE_LARGE: 15
   PEN_COLOR_RED: 'red'
   PEN_COLOR_GREEN: 'green'
   PEN_COLOR_BLUE: 'blue'
   PEN_COLOR_DEFAULT: 'black'
   
   #The background layer
   background: null
   #The layer the user draws on
   canvas: null
   
   #Sets the pen to eraser mode
   activateEraser: ->
      @canvas.startErasing()
      
   #Sets the "pen" to draw mode. This is the default.
   activatePen: ->
      @canvas.startDrawing()
      
   setPenSize: (size) ->
      if size && parseInt(size) isnt NaN
         @canvas.penSize = size
   
   setPenColor: (color) ->
      if color isnt @PEN_COLOR_RED and color isnt @PEN_COLOR_GREEN and color isnt @PEN_COLOR_BLUE 
         @canvas.penColor = @PEN_COLOR_DEFAULT
      else
         @canvas.penColor = color
         
   regularPaper: ->
      @background.removeChildren()
      @background.draw()
        
   graphPaper: ->
      @background.removeChildren()
      @grid()
      @background.draw()
      
   linedPaper: ->
      @background.removeChildren()
      @makeRules('horizontal')
      @background.draw()
      
   clearAll: ->
      @canvas.clear()

   #Converts the canvas layer to an image and writes the image to a popup window. The created
   #popup window is returned
   showCanvas: ->
      cnv = @canvas.getCanvas()._canvas
      w = window.open()
      w.document.write '<img src="' + cnv.toDataURL("image/png") + '" width="'+@WIDTH+'" height="'+@HEIGHT+'"/>'
      w
      
   showAll: ->
      w = window.open()
      
      cnv = @canvas.getCanvas()._canvas
      bg = @background.getCanvas()._canvas
      
      cnvURL = cnv.toDataURL()
      bgURL = bg.toDataURL()
      
      newCanvas = document.createElement('CANVAS')
      newCanvas.width = @WIDTH
      newCanvas.height = @HEIGHT
      ctx = newCanvas.getContext('2d')
      
      bgImg = new Image
      bgImg.onload = ->
         ctx.drawImage(bgImg,0,0)
      bgImg.src = bgURL
      
      cnvImg = new Image
      #When the second image is finished loading, add it to the new canvas, get a dataURL representing that canvas's image, then write
      #the image to the popup window so the user can save it.
      cnvImg.onload = =>
         ctx.drawImage(cnvImg,0,0)
         w.document.write '<img src="' + newCanvas.toDataURL("image/png") + '" width="'+@WIDTH+'" height="'+@HEIGHT+'"/>'
      cnvImg.src = cnvURL
      
      w
      
   #Prints ONLY the canvas layer -- the background will be ignored.   
   printCanvas: ->
      w = @showCanvas()
      #We need to close the document and focus on the window before printing for cross-browser functionality. 
      #See this SO question: http://stackoverflow.com/questions/2555697/window-print-not-working-in-ie
      w.document.close()
      w.focus()
      w.print()
      w.close()
      
   #Prints both the background and the canvas.
   printAll: ->
      #This relies on special print-only CSS. See main.css.
      window.print();
         
   constructor: ->
      @HEIGHT = Math.floor(@WIDTH * 1.29411764706)
      @setupStage()
      @setupBackground()
      @setupCanvas()
   
   setupStage: ->
      @stage = new Kinetic.Stage
         container: 'easynote'
         width: @WIDTH
         height: @HEIGHT
         
   setupBackground: ->
      @background = new Kinetic.Layer()
      @grid()
      @stage.add(@background)
      
   setupCanvas: ->
      @canvas = new Kinetic.Layer()
      window.canvas = @canvas
      @stage.add(@canvas)
      #Unfortunately, we have to work outside of KineticJS to get drawing functionality.
      #Extend the canvas object's API
      @extendCanvas()
      
      #Add mouse listeners to the actual canvas object
      #Note that we need to subtract the offset produced by the fact
      #that the canvas isn't flush with the screen corners
      cnv = @canvas.getCanvas()._canvas
      $(cnv).on 'mousedown', (event) =>
         offset = $(cnv).offset()
         @canvas.beginLine event.pageX - offset.left, event.pageY - offset.top
      $(cnv).on 'mousemove', (event) =>
         offset = $(cnv).offset()
         @canvas.drawLine event.pageX - offset.left, event.pageY - offset.top
      $(cnv).on 'mouseup', =>
         @canvas.endLine()
         
   #Adds additional functionality to the @canvas object so that the user can draw and erase.
   extendCanvas: ->
      @canvas.drawing = false
      @canvas.context = @canvas.getCanvas()._canvas.getContext '2d'
      #set default drawing values
      @canvas.penColor = @PEN_COLOR_DEFAULT
      @canvas.penSize = @PEN_SIZE_SMALL
      @canvas.context.lineCap='round'
      @canvas.context.lineJoin='round'
      @canvas.context.strokeStyle = @canvas.penColor
      @canvas.context.lineWidth = @canvas.penSize
      #add in custom functions
      @canvas.beginLine = (x,y) ->
         @drawing = true
         #default values below; can and will be updated on the fly
         @context.strokeStyle = @penColor
         @context.lineWidth = @penSize
         @context.beginPath()
         @context.moveTo(x,y)
      
      @canvas.drawLine = (x,y) ->
         if !@drawing
            return
         @context.lineTo(x,y)
         @context.stroke()
         
      @canvas.endLine = ->
         @drawing = false
      
      #Modifies the canvas context so that the user mouse actions
      #erase instead of draw.
      @canvas.startErasing = ->
         @context.globalCompositeOperation = 'destination-out'
         @context.strokeStyle = 'rgba(0,0,0,1)'
      
      @canvas.startDrawing = ->
         @context.globalCompositeOperation = 'source-over'
         @context.strokeStyle = @penColor

   makeRule: (coord, horizontal) ->
      points
      if horizontal
         points = [0, coord, @WIDTH, coord]
      else
         points = [coord, 0, coord, @HEIGHT]      
      new Kinetic.Line
            points: points
            stroke: 'blue'
            strokeWidth: 1
      
   grid: ->
      @makeRules('both')
      
   makeRules: (kind) ->
      lines = []
      if kind is "horizontal" or kind is "both"
         lines.push @makeRule(y, true) for y in [0..@HEIGHT] by @LINE_SPACE
      if kind is "vertical" or kind is "both"
         lines.push @makeRule(x, false) for x in [0..@WIDTH] by @LINE_SPACE
      @background.add line for line in lines
      
   redraw: ->
      @stage = null
      @setupStage()
      @stage.add(@background)