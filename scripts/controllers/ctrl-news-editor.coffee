angular.module('appLibs').controller "NewsEditorCtrl", ($scope, $newsSvc, $core, $modal) ->

  $newsSvc.all().then (news) ->
    $scope.news = news

  alerts = $scope.alerts = []
  $scope.isHiden = (news) ->
    if news.published or $scope.activeHiden
      return true
    else
      return false

  $scope.onDelete = (index, aNew) ->
    console.log("onDelete", index, aNew)
    if confirm("Удалить новость?")
      _.remove $scope.news, (n) -> n._id == aNew._id
      $newsSvc.delete(aNew._id).then ->
        alerts.push({type: "danger", msg: "Удалено!"})

  $scope.onEditOrAdd = (index, news) ->
    editMode = if news then true else false
    console.log("onEditOrAdd", index, news)

    modalInstance = $modal.open
      templateUrl: 'newsModalContent.html'
      controller: ($scope, $modalInstance) ->

        if editMode
          $scope.newNews = angular.copy(news)
        else
          $scope.newNews = {
            type: "news"
            body: "<p>Описание...<a href=\"https://www.adoberevel.com/shares/e7f7eabd3da14f56aff7f33cc7f3649f\" target=\"_blank\" class=\"btn btn-info btn-sm more\">Фото →</a> <a href=\"https://www.youtube.com/watch?v=NBONP440yyA\" target=\"_blank\" class=\"btn btn-info btn-sm more\">Видео →</a> <a href=\"http://blog.bratstvost.by/post/84320352964\" target=\"_blank\" class=\"btn btn-info btn-sm more\">Читать →</a></p>"
            date: moment().toISOString()
            published: yes
            created: moment().toISOString()
            updated: moment().toISOString()
          }

        getNewsObj = (newNews) ->
          news = angular.copy(newNews)
          news.body = newNews.body.trim()
          news.updated = new Date

          return news

        $scope.newsJSON = JSON.stringify(getNewsObj($scope.newNews), null, "  ")

        $scope.$watchCollection "newNews", ->
          $scope.newsObj = getNewsObj($scope.newNews)
          $scope.newsJSON = JSON.stringify($scope.newsObj, null, "  ")

        $scope.save = ->
          result = getNewsObj($scope.newNews)
          console.log "SAVE NEWS", result
          $modalInstance.close(result)

        $scope.cancel = ->
          $modalInstance.dismiss('cancel')

    .result.then (aNews) ->
      if editMode
        index = _.findIndex $scope.news, (news) ->
          return news._id == aNews._id
        console.log("CHECK", index, $scope.news, $scope.news[index], aNews)
        $scope.news[index] = aNews
        $newsSvc.save(aNews._id, aNews).then ->
          alerts.push({type: "warning", msg: "Обновлено!"})
      else
        $scope.news.push(aNews)
        $newsSvc.create(aNews).then (d) ->
          aNews._id = d._id
          alerts.push({type: "success", msg: "Добавлено!"})
    , ->
      console.log "Modal dismissed"
