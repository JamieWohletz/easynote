class window.Notebook
   #CONSTANT: The Kinetic.Layer object representing the current page
   @CANVAS: null
   #A pointer to our current spot in the pages array. Default is 0
   @currentPage: null
   #Array of 'pages', which are just data URLs corresponding to what the user has drawn
   @pages: null
   #LocalStorage keys -- set in constructor
   @CURRENT_PAGE_KEY: null 
   @NOTEBOOK_KEY: null
   
   constructor: (canvas) ->
      @CURRENT_PAGE_KEY = 'easynote_currentPage'
      @NOTEBOOK_KEY = 'easynote_notebook'
      @CANVAS = canvas
      @currentPage = 0
      @pages = []
      #Try to restore a previous state; if there is none, just load regularly
      unless @restoreState()
         #We assume the starting page is the first page in the notebook
         @pages.push @CANVAS.getCanvas().toDataURL('image/png')
      
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
      @pages[@currentPage] = @CANVAS.getCanvas().toDataURL('image/png')
   
   loadPage: ->
      @CANVAS.destroyChildren()
      @CANVAS.clear()
      return if @pages[@currentPage] is null
      
      ctx = @CANVAS.getContext()
      dataURL = @pages[@currentPage]
      img = new Image
      img.onload = =>
         ctx.drawImage img, 0, 0, @CANVAS.getCanvas().width, @CANVAS.getCanvas().height
      img.src = dataURL
      
   #Saves each notebook page (as well as the current page pointer) in local storage for later retrieval.
   saveState: ->
      return if typeof window.localStorage isnt 'object'
      #make sure the current page is saved
      @savePage()
      localStorage[@CURRENT_PAGE_KEY] = @currentPage 
      localStorage[@NOTEBOOK_KEY] = JSON.stringify(@pages)
      
   #Restores the previously saved state (see saveState())
   restoreState: ->
      return false if typeof window.localStorage isnt 'object' or !localStorage[@NOTEBOOK_KEY]? or !localStorage[@CURRENT_PAGE_KEY]?
      
      @pages = JSON.parse localStorage[@NOTEBOOK_KEY]
      @currentPage = parseInt(localStorage[@CURRENT_PAGE_KEY])
      ctx = @CANVAS.getContext()
      #load the current page
      @loadPage()
      true
      