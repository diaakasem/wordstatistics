'use strict'

controller = (scope, ParseCrud, http, ngTableParams, Alert)->

  scope.text = ''
  scope.filesUploaded = []      #list of files uploaded in one run; this will need to be added in parse...
  scope.entity = {}
  scope.data = []
  scope.selected = 'upload'
  Documents = new ParseCrud 'Documents'
  DocumentUpload = new ParseCrud 'DocumentUpload'
  FilesUpload = new ParseCrud 'FilesUpload'   #in case user selects multiple documents, this collection will hold them...
  
  DocumentUpload.list (d)->
    scope.data = d
    scope.tableParams.reload()
    console.log d


  removeFile = (name)->
    params =
      method: 'POST'
      url: '/removeupload'
      data:
        filename: name
    h = http params
    h.success (d)->
      Alert.success 'Removed successfully.'
      # scope.tableParams.reload()
    h.error (e)->
      console.log e
      Alert.error "Error removing uploaded file."

  scope.remove = (e)->
    return  unless scope.hasWriteAccess(e)
    filename = e.get('uploadname')

    removeSuccess = (e)->
      
      #refresh the Archive list...
      DocumentUpload.list (d)->
        scope.data = d
        scope.tableParams.reload()

      #scope.data = _.filter scope.data, (d)-> d.id isnt e.id

      #If this document was uploaded by a user (non-admin), it was also uploaded to 'Documents' collection,
      #so we need to remove it from 'Documents' collection too...
      unless scope.$root.isAdmin

        #fetch the associated Document in the 'Documents' collection
        #This is assuming that 'name' of the uploaded document is unique for a given user...
       
        query = new Parse.Query 'Documents'
        query.equalTo 'name', e.get('name')
        query.first
          success: (associatedDoc)->
            Documents.remove associatedDoc, (result)->
              console.log result

      #If filename is defined, its only a single document,
      #else its a table of documents, so we need to query the filenames separately...

    if filename
      removeFile filename
    else
      #query FilesUpLoad to fetch files associated with this 'DocumentUpload' object...
      query = new Parse.Query 'FilesUpload'
      query.equalTo 'parent', e
      query.find
        success: (files)->

          files.forEach (file, i)->
            filename = file.get('uploadname')
            console.log filename
            removeFile filename

            #remove the file from parse...
            file.destroy()

    #now destroy the documentUpload object...
    DocumentUpload.remove(e, removeSuccess)


  scope.tableParams = new ngTableParams
    page: 1
    count: 10
  ,
    total: -> scope.data.length
    getData: ($defer, params) ->
      start = (params.page() - 1) * params.count()
      end = params.page() * params.count()
      $defer.resolve scope.data.slice(start, end)

  uploader = new plupload.Uploader
    browse_button: "browse"
    url: "/upload"
    filters:
      mime_types: [ {title : "Text files", extensions : "txt"},
                    {title: "Doc files", extensions: "doc,docx"} ],
      max_file_size: "50mb"

  uploader.init()

  scope.filesAdded = []

  uploader.bind "FilesAdded", (up, files) ->
    scope.$apply ->
      plupload.each files, (file) ->
        scope.filesAdded.push file

  scope.hasWriteAccess = (obj)->
    return false  unless obj
    acl = obj.getACL()
    acl.getWriteAccess(scope.$root.user)

  documentSaveSuccess = (e)->
    (doc)->
      scope.$apply ->
        # scope.data.push e
        # scope.tableParams.reload()
        scope.selected = 'uploaded'
        Alert.success "File was uploaded successfully. &nbsp;&nbsp;
        <a href='#upload'>Upload more documents</a> |
        <a href='#/processes'>Run analyses</a>"


  saveSuccess = (e)->
    console.log "Save success!"
    console.log e
    unless scope.$root.isAdmin
      Documents.save {
        name: e.get('name')
        uploadedDocument: e
      }, documentSaveSuccess(e), saveError
    else
      scope.$apply ->
        # scope.data.push e
        # scope.tableParams.reload()
        scope.selected = 'uploaded'
        Alert.success "File was uploaded successfully. &nbsp;&nbsp;
        <a href='#upload'>Upload more documents</a> |
        <a href='#/processes'>Run analyses</a>"

    #refresh the Archive list...
      DocumentUpload.list (d)->
        scope.data = d
        scope.tableParams.reload()


  saveError = (e)->
    scope.$apply ->
      console.log e
      Alert.error "Error occured while saving upload info."

  uploader.bind 'FileUploaded', (up, file, xhr)->
    res = JSON.parse xhr.response
    scope.filesUploaded.push(res.result)
   

  uploader.bind 'UploadComplete', (up, files) ->

    #add logic here to determine if user added only 1 file in the current run or not.
    #if only 1 file was added, the logic is straight-forward, simply add the file to parse,
    #if, however, multiple files were selected, we need to add 1 row to the 
    # 'DocumentUpload' collection, and the list of all files as a relation to this row to 'FilesUpload' collection...

    files_obj = []
    files.forEach (file, i)->
      obj =
        filename: file.name
        uploadname: scope.filesUploaded[i]

      files_obj.push(obj)
      
    if files_obj.length == 1
      #its only a single document, so add the name directly here and save...
      files_obj[0].name = scope.name
      DocumentUpload.save files_obj[0], saveSuccess, saveError
    else
      
      #multiple documents: save them as a child of the main DocumentUpload object...
      Document = Parse.Object.extend 'DocumentUpload'
      document = new Document()
      document.set 'name', scope.name
      document.set 'filename', '<multiple files...>'              #might need to improve this line...
      document.setACL(new Parse.ACL(Parse.User.current()))

      File = Parse.Object.extend 'FilesUpload'
      filesArray = []

      files_obj.forEach (obj, i)->
        file = new File()
        file.set 'filename', obj.filename
        file.set 'uploadname', obj.uploadname
        file.set 'parent', document
        file.setACL(new Parse.ACL(Parse.User.current()))

        filesArray.push(file)

      Parse.Object.saveAll filesArray, 
        success: (objs)->
          saveSuccess document      #at the end, call the saveSuccess method to do cleanup...

        error: (error)->
          console.log error
  

    uploader.splice()     #re-init the uploader, so that new files can be added...
    
    scope.$apply ->
      scope.filesAdded.length = 0
      scope.name = ''
      scope.filesToUpload = []
      scope.filesUploaded = []
      files = []

  uploader.bind 'UploadProgress', (up, file) ->
    scope.$apply ->
      matches = _.filter scope.filesAdded, (f)-> f.id is file.id
      matches[0].percent = file.percent

  uploader.bind 'Error', (up, err) ->
    scope.$apply ->
      console.log err
      Alert.error "Error uploading the file."

  scope.upload = ->
    Alert.clear()
    uploader.start()

angular.module('wordsApp')
  .controller 'UploadsUploadsCtrl',
  ['$scope', 'ParseCrud', '$http', 'ngTableParams', 'Alert', controller]