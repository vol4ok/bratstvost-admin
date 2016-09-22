angular.module('appLibs').controller "NoticeEditorCtrl", ($scope, $noticeSvc, $core, $modal, $filter) ->

  $noticeSvc.all().then (notices) ->
    $scope.notices = notices

  alerts = $scope.alerts = []
  $scope.isHiden = (notice) ->
    if notice.published and new Date(notice.show_ends) > new Date()
      return true
    else if $scope.activeHiden
      return true
    else
      return false

  $scope.onDelete = (index, notice) ->
    if confirm("Удалить объявление?")
      _.remove $scope.notices, (note) -> note._id == notice._id
      $noticeSvc.delete(notice._id).then ->
        alerts.push({type: "danger", msg: "Удалено!"})

  $scope.onEditOrAdd = (index, note) ->
    editMode = if note then true else false

    modalInstance = $modal.open
      templateUrl: 'modalContent.html'
      controller: ($scope, $modalInstance) ->

        $scope.datepicker = { isOpen: false }

        if editMode
          $scope.newNotice = angular.copy(note)
        else
          $scope.newNotice = {
            type: "notice"
            body: ""
            show_begins: moment().toISOString()
            show_ends: "9999-11-11T23:59:59.999Z"
            priority: 0
            style: ""
            published: yes
            created: moment().toISOString()
            updated: moment().toISOString()
          }

        getNoticeObj = (newNotice) ->
          notice = angular.copy(newNotice)
          notice.body = newNotice.body.trim()
          notice.updated = new Date

          return notice

        $scope.noticeJSON = JSON.stringify(getNoticeObj($scope.newNotice), null, "  ")

        $scope.$watchCollection "newNotice", ->
          $scope.noticeObj = getNoticeObj($scope.newNotice)
          $scope.noticeJSON = JSON.stringify($scope.noticeObj, null, "  ")

        $scope.save = ->
          result = getNoticeObj($scope.newNotice)
          $modalInstance.close(result)

        $scope.cancel = ->
          $modalInstance.dismiss('cancel')

    .result.then (notice) ->
      if editMode
        index = _.findIndex $scope.notices, (note) ->
          return note._id == notice._id
        $scope.notices[index] = notice
        $noticeSvc.save(notice._id, notice).then ->
          alerts.push({type: "warning", msg: "Обновлено!"})
      else
        $scope.notices.push(notice)
        $noticeSvc.create(notice).then (d) ->
          notice._id = d._id
          alerts.push({type: "success", msg: "Добавлено!"})
    , ->
      console.log "Modal dismissed"
