angular.module('appLibs').controller "VideoEditorCtrl", ($scope, $videoSvc, $core, $modal) ->

  $videoSvc.all().then (videos) ->
    $scope.videos = videos

  alerts = $scope.alerts = []
  $scope.isHiden = (video) ->
    if video.published
      return true
    else if $scope.activeHiden
      return true
    else
      return false

  $scope.onDelete = (index, video) ->
    console.log("onDelete", index, video)
    if confirm("Удалить видео?")
      _.remove $scope.videos, (vid) -> vid._id == video._id
      $videoSvc.delete(video._id).then ->
        alerts.push({type: "danger", msg: "Удалено!"})

  $scope.onEditOrAdd = (index, cVideo) ->
    editMode = if cVideo then true else false
    console.log("onEditOrAdd", index, cVideo)

    modalInstance = $modal.open
      templateUrl: 'videoModalContent.html'
      controller: ($scope, $modalInstance) ->

        $scope.datepicker = { isOpen: false }

        if editMode
          $scope.newVideo = angular.copy(cVideo)
        else
          $scope.newVideo = {
            video_id: "_REPLACE_ME_"
            title: ""
            content: ""
            url: "http://www.youtube.com/embed/_REPLACE_ME_?feature=player_embeded&autoplay=1"
            thumb_url: "http://img.youtube.com/vi/_REPLACE_ME_/0.jpg"
            source_url: ""
            published: yes
            publish_date: moment().toISOString()
            created: moment().toISOString()
            updated: moment().toISOString()
          }

        getVideoObj = (newVideo) ->
          video = angular.copy(newVideo)
          video.updated = new Date

          return video

        $scope.videoJSON = JSON.stringify(getVideoObj($scope.newVideo), null, "  ")

        $scope.$watchCollection "newVideo", ->
          $scope.videoObj = getVideoObj($scope.newVideo)
          $scope.videoJSON = JSON.stringify($scope.videoObj, null, "  ")

        $scope.save = ->
          result = getVideoObj($scope.newVideo)
          console.log "SAVE VIDEO", result
          $modalInstance.close(result)

        $scope.cancel = ->
          $modalInstance.dismiss('cancel')

    .result.then (video) ->
      if editMode
        index = _.findIndex $scope.videos, (cVideo) ->
          return cVideo._id == video._id
        console.log("CHECK", index, $scope.videos, $scope.videos[index], video)
        $scope.videos[index] = video
        $videoSvc.save(video._id, video).then ->
          alerts.push({type: "warning", msg: "Обновлено!"})
      else
        $scope.videos.push(video)
        $videoSvc.create(video).then (d) ->
          video._id = d._id
          alerts.push({type: "success", msg: "Добавлено!"})
    , ->
      console.log "Modal dismissed"
