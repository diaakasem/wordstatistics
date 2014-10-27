controller = (scope, ParseCrud,  ngTableParams, http, Alert) ->
  
  scope.data = []

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


  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      $defer.resolve scope.data.slice((params.page() - 1) * params.count(), params.page() * params.count())

angular.module('wordsApp')
  .controller 'MainCtrl',
  ['$scope', 'ParseCrud', 'ngTableParams', '$http', 'Alert', controller]
