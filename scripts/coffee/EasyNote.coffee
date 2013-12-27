class EasyNote
   WIDTH: (window.innerWidth / 100) * 80
   #The height is set in the constructor and is proportional 
   #to the window width; this ratio comes from 
   #standard letter paper dimensions (8.5 x 11). 
   HEIGHT: null
   LINE_SPACE: 20
   
   #The background layer
   background: null
   #The layer the user draws on
   canvas: null
   
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
      @canvas.drawing = false
      @canvas.beginLine = (x,y) ->
         @drawing = true
         @startX = x
         @startY = y
      
      @canvas.drawLine = (x,y) ->
         if !@drawing
            return
         line = new Kinetic.Line
            points: [@startX, @startY, x, y]
            stroke: 'black'
            strokeWidth: 10
            lineCap: 'round'
            lineJoin: 'round'
         @add(line)
         @startX = x
         @startY = y
         @getParent().drawScene()
         
      @canvas.endLine = ->
         @drawing = false
         @getParent().draw()
      
      #Add mouse listeners to the actual canvas object
      cnv = @canvas.getCanvas()._canvas
      $(cnv).on 'mousedown', (event) =>
         console.log 'down'
         offset = $(event.currentTarget).offset()
         @canvas.beginLine event.clientX - offset.left, event.clientY - offset.top
      $(cnv).on 'mousemove', (event) =>
         console.log 'move'
         offset = $(event.currentTarget).offset()
         @canvas.drawLine event.clientX - offset.left, event.clientY - offset.top
      $(cnv).on 'mouseup', =>
         console.log 'up'
         @canvas.endLine()
         

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
      @background.clear()
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
      
#Create the class      
new EasyNote