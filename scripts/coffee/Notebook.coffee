class window.Notebook
   #CONSTANT: The Kinetic.Layer object representing the current page
   @CANVAS: null
   #A pointer to our current spot in the pages array. Default is 0
   @currentPage: null
   #Array of 'pages', which are just data URLs corresponding to what the user has drawn
   @pages: null
   #The notebook directly corresponds to a canvas element, so one
   #is required by its constructor
   constructor: (canvas) ->
      @CANVAS = canvas
      @currentPage = 0
      @pages = []
      #Try to restore a previous state; if there is none, just load regularly
      unless @restoreState()
         #We assume the starting page is the first page in the notebook
         @pages.push @CANVAS.getCanvas().toDataURL()
      
   getCurrentPageIndex: ->
      @currentPage+1
      
   nextPage: ->
      #save the current page
      @savePage()
      if @currentPage is @pages.length-1
         #push an empty page (null) onto the end of the array
         @pages.push null
      @currentPage++
      @loadPage()
      
   previousPage: ->
      unless @currentPage is 0
         @savePage()
         @currentPage--
         @loadPage()
         
   savePage: ->
      @pages[@currentPage] = @CANVAS.getCanvas().toDataURL()
   
   loadPage: ->
      @CANVAS.destroyChildren()
      @CANVAS.clear()
      return if @pages[@currentPage] is null
      
      ctx = @CANVAS.getContext()
      dataURL = @pages[@currentPage]
      img = new Image
      img.onload = ->
         ctx.drawImage img, 0, 0
      img.src = dataURL
      
   #Saves each notebook page (as well as the current page pointer) in local storage for later retrieval.
   saveState: ->
      return if !localStorage
      localStorage['easynote_currentPage'] = @currentPage 
      localStorage['easynote_notebook'] = JSON.stringify(@pages)
      
   #Restores the previously saved state (see saveState())
   restoreState: ->
      return false if !localStorage? or !localStorage['easynote_notebook']? or !localStorage['easynote_currentPage']?
      
      @pages = JSON.parse localStorage['easynote_notebook']
      @currentPage = parseInt(localStorage['easynote_currentPage'])
      ctx = @CANVAS.getContext()
      #load the current page
      cnvImg = new Image
      cnvImg.onload = ->
         ctx.drawImage(cnvImg,0,0)
      cnvImg.src = @pages[@currentPage]
      true
      