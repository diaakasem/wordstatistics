controller = (scope, ParseCrud,  ngTableParams, http, Alert) ->

  scope.data = []
  scope.selected = 'new'
  scope.entity = {}
  scope.files = {}

  Documents = new ParseCrud 'Documents'
  Documents.list (d)->
    scope.documents = d

  WordsLists = new ParseCrud 'WordsLists'
  WordsLists.list (d)->
    scope.wordslists = d


  Processes = new ParseCrud 'Processes'
  Processes.listWith ['wordslist', 'documents'], (d)->
    scope.data = d
    scope.tableParams.reload()

  Uploads = new ParseCrud 'DocumentUpload'

  scope.save = ->
    doProcess = _.after 2, ->
      Alert.warn 'Processing is in progress, please, be patient.'
      params =
        method: 'POST'
        url: '/analyzefiles'
        data: scope.files
          
      h = http params
      h.success (d)->
        
        scope.entity.result = d.result

        Processes.save scope.entity, saveSuccess, onError
        scope.tableParams.reload()
        Alert.success 'Processed successfully.'
      h.error (e)->
        Alert.success 'Error occured.'
        console.log e

    
    scope.entity.documents.get('uploadedDocument').fetch
      success: (documentFile)->
         scope.$apply ->

          if documentFile.get('uploadname')               #check if just a single file...
            scope.files.document = documentFile.get('uploadname')
            scope.files.filename = documentFile.get('filename')
            doProcess()         
          else

            #if documentFile consists of many files, fetch all the files associated with it;
            #in case of multiple files, documentFile doesn't have 'uploadname' associated with it...
            query = new Parse.Query 'FilesUpload'
            query.equalTo 'parent', documentFile
            query.find
              success: (files)->

                uploadnames = []
                filenames = []

                files.forEach (file, i)->
                  uploadnames.push(file.get('uploadname'))
                  filenames.push(file.get('filename'))

                scope.files.document = uploadnames
                scope.files.filename = filenames
                doProcess()


    scope.entity.wordslist.get('uploadedDocument').fetch
      success: (wordsFile)->
        scope.$apply ->
          scope.files.words = wordsFile.get('uploadname')
          doProcess()

      error: (err)->
        console.log "err"


  scope.visualize = (wordslist)->

    #first find the uploadedDocument associated with this wordslist..
    wordslist.get('uploadedDocument').fetch
      success: (documentFile)->

        uploadname = documentFile.get('uploadname')
        name = wordslist.get('name')

        #Pass the uploadname to the server to get visualization data
        params =
            method: 'Get'
            url: '/visualize-wordslist?name='+name+'&uploadname='+uploadname
        
        h = http params
        h.success (d)->
          console.log d

          margin =
            top: 20
            right: 120
            bottom: 20
            left: 120

          width = 960 - margin.right - margin.left
          height = 500 - margin.top - margin.bottom
          i = 0
          duration = 750

          tree = d3.layout.tree()
            .size([
              height
              width
            ])

          diagonal = d3.svg.diagonal()
          .projection((d) ->
            [
              d.y
              d.x
            ]
          )

          svg = d3.select(".visualize")
            .append("svg")
            .attr("width", width + margin.right + margin.left).attr("height", height + margin.top + margin.bottom)
            .append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")

          d3.select(self.frameElement).style "height", "800px"
          
          collapse = (d) ->
            if d.children
              d._children = d.children
              d._children.forEach collapse
              d.children = null


          update = (source) ->
  
            # Compute the new tree layout.
            nodes = tree.nodes(root).reverse()
            links = tree.links(nodes)
            
            # Normalize for fixed-depth.
            nodes.forEach (d) ->
              d.y = d.depth * 180
              #return

            # Update the nodes…
            node = svg.selectAll("g.node").data(nodes, (d) ->
              d.id or (d.id = ++i)
            )
            
            # Enter any new nodes at the parent's previous position.
            nodeEnter = node.enter().append("g").attr("class", "node").attr("transform", (d) ->
              "translate(" + source.y0 + "," + source.x0 + ")"
            ).on("click", click)
            
            nodeEnter.append("circle").attr("r", 1e-6).style "fill", (d) ->
              (if d._children then "lightsteelblue" else "#fff")

            nodeEnter.append("text").attr("x", (d) ->
              (if d.children or d._children then -10 else 10)
            ).attr("dy", ".35em").attr("text-anchor", (d) ->
              (if d.children or d._children then "end" else "start")
            ).text((d) ->
              d.name
            ).style "fill-opacity", 1e-6
            
            # Transition nodes to their new position.
            nodeUpdate = node.transition().duration(duration).attr("transform", (d) ->
              "translate(" + d.y + "," + d.x + ")"
            )

            nodeUpdate.select("circle").attr("r", 4.5).style "fill", (d) ->
              (if d._children then "lightsteelblue" else "#fff")

            nodeUpdate.select("text").style "fill-opacity", 1
            
            # Transition exiting nodes to the parent's new position.
            nodeExit = node.exit().transition().duration(duration).attr("transform", (d) ->
              "translate(" + source.y + "," + source.x + ")"
            ).remove()

            nodeExit.select("circle").attr "r", 1e-6
            nodeExit.select("text").style "fill-opacity", 1e-6
            
            # Update the links…
            link = svg.selectAll("path.link").data(links, (d) ->
              d.target.id
            )
            
            # Enter any new links at the parent's previous position.
            link.enter().insert("path", "g").attr("class", "link").attr "d", (d) ->
              o =
                x: source.x0
                y: source.y0

              diagonal
                source: o
                target: o


            # Transition links to their new position.
            link.transition().duration(duration).attr "d", diagonal
            
            # Transition exiting nodes to the parent's new position.
            link.exit().transition().duration(duration).attr("d", (d) ->
              o =
                x: source.x
                y: source.y

              diagonal
                source: o
                target: o

            ).remove()
            
            # Stash the old positions for transition.
            nodes.forEach (d) ->
              d.x0 = d.x
              d.y0 = d.y
              #return

            # return

          # Toggle children on click.
          click = (d) ->
            if d.children
              d._children = d.children
              d.children = null
            else
              d.children = d._children
              d._children = null
            update d
            #return
          
          root = d
          root.x0 = height / 2
          root.y0 = 0

          root.children.forEach collapse
          update root

          
        h.error (e)->
          console.log e


  scope.get = (parseObj, attr='name')->
    parseObj.fetch
      success: (obj)->
        obj.get(attr)
    
  saveSuccess = (e)->
    scope.$apply ->
      scope.data.push e
      scope.tableParams.reload()
      scope.selected = 'list'
      Alert.success 'Process information was saved successfully.'
    
  onError = (e)->
    scope.$apply ->
      console.log e
      Alert.error 'Error occured while saving process information.'

  removeFile = (name)->
    params =
      method: 'POST'
      url: '/remove'
      data:
        filename: name
    h = http params
    h.success (d)->
      scope.$apply ->
        Alert.success 'Removed successfully.'
        scope.tableParams.reload()
    h.error (e)->
      scope.$apply ->
        Alert.error e

  scope.remove = (entity)->
    entity.destroy
      success: ->
        scope.$apply ->
          Alert.success 'Removed successfully.'
          scope.data = _.filter scope.data, (d)-> d.id isnt entity.id
          scope.tableParams.reload()
      error: (e)->
        console.log e
        scope.$apply ->
          Alert.error 'Error occurred while removing.'

  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      $defer.resolve scope.data.slice((params.page() - 1) * params.count(), params.page() * params.count())

angular.module('wordsApp')
  .controller 'ProcessesCtrl',
  ['$scope', 'ParseCrud', 'ngTableParams', '$http', 'Alert', controller]
