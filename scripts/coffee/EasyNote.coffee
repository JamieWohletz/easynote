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
      @extendCanvas()
      
      #Add mouse listeners to the actual canvas object
      #Note that we need to subtract the offset produced by the fact
      #that the canvas isn't flush with the screen corners
      cnv = @canvas.getCanvas()._canvas
      offsetX = cnv.getBoundingClientRect().left
      offsetY = cnv.getBoundingClientRect().top
      $(cnv).on 'mousedown', (event) =>
         #offset = $(event.currentTarget).offset()
         @canvas.beginLine event.pageX - offsetX, event.pageY - offsetY
      $(cnv).on 'mousemove', (event) =>
         offset = $(event.currentTarget).offset()
         @canvas.drawLine event.pageX - offsetX, event.pageY - offsetY
      $(cnv).on 'mouseup', =>
         @canvas.endLine()
         
   #Adds additional functionality to the @canvas object so that the user can draw and erase.
   extendCanvas: ->
      @canvas.drawing = false
      @canvas.context = @canvas.getCanvas()._canvas.getContext '2d'
      @canvas.beginLine = (x,y) ->
         @drawing = true
         #default values below; can and will be updated on the fly
         @context.beginPath()
         @context.lineCap='round'
         @context.lineJoin='round'
         @context.strokeStyle = 'black'
         @context.lineWidth = '5'
         @context.moveTo(x,y)
      
      @canvas.drawLine = (x,y) ->
         if !@drawing
            return
         @context.lineTo(x,y)
         @context.stroke()
         
      @canvas.endLine = ->
         @drawing = false

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