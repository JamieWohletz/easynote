class EasyNote
   WIDTH: 800
   HEIGHT: 800
   LINE_SPACE: 20
   constructor: ->
      @setupStage()
      console.log 'set up stage'
      @setupBackground()
   
   setupStage: ->
      @stage = new Kinetic.Stage
         container: 'easynote'
         width: @WIDTH
         height: @HEIGHT
         
   setupBackground: ->
      @background = new Kinetic.Layer()
      @grid()
      @stage.add(@background)

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