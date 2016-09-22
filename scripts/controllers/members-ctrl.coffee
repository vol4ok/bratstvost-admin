angular.module('appLibs').directive 'modalWindow', ->
  return {
    restrict: 'EA'
    link: (scope, element) ->
      element.find('.modal-dialog').addClass('modal-lg')
    }

angular.module('appLibs').controller "MembersCtrl", ($scope, $core, $modal, uuid4, phoneHelpers, textHelpers) ->

    {filterText, stripP, FSM} = textHelpers

    $core.$members.all().then (members) ->
      $scope.members = members

    alerts = $scope.alerts = []

    $scope.isHiden = (member) ->
      if member.active or $scope.activeHiden
        return true
      else
        return false

    $scope.onDelete = (index, member) ->
      if confirm("Удалить #{member.fullName}?")
        _.remove $scope.members, (memb) -> memb._id == member._id
        $core.$members.delete(member._id).then ->
          alerts.push({type: "danger", msg: "Удалено!"})

    $scope.onEditOrAdd = (index, memb) ->
      editMode = if memb then true else false

      modalInstance = $modal.open
        templateUrl: 'myModalContent.html'
        controller: ($scope, $modalInstance) ->

          $scope.datepickerBD = { isOpen: false }
          $scope.datepickerAD = { isOpen: false }

          if editMode
            $scope.newMember = angular.copy(memb)
          else
            $scope.newMember = {
               fullName: ''
               lastName: ''
               firstName: ''
               middleName: ''
               position: ''
               male: yes
               photoId: ''
               phone: ''
               email: ''
               skype: ''
               info: ''
               birthDate:''
               angelDate:''
               active: yes
               orderNumber: 50 }

          getMemberObj = (newMember) ->
            if editMode
              member = angular.copy(memb)
            else
              member = { created : new Date }

            member.fullName = newMember.fullName.trim()
            names = member.fullName.split(" ")
            member.lastName = newMember.lastName || names[0] || ""
            member.firstName = newMember.firstName || names[1] || ""
            member.middleName = newMember.middleName || names[2] || ""
            member.male = !!newMember.male
            member.brotherName = (if member.male then "брат " else "сестра ") + member.firstName
            member.position = filterText(newMember.position).trim()
            member.photoId = newMember.photoId.trim()
            member.email = newMember.email.trim()
            member.skype = newMember.skype.trim()
            member.info = FSM(newMember.info)
            member.phone = newMember.phone
            member.active = !!newMember.active
            member.orderNumber = newMember.orderNumber
            member.birthDate = newMember.birthDate
            member.angelDate  = newMember.angelDate
            member.updated = new Date

            return member

          $scope.memberJSON = JSON.stringify(getMemberObj($scope.newMember), null, "  ")

          $scope.$watchCollection "newMember", ->
            $scope.memberObj = getMemberObj($scope.newMember)
            $scope.memberJSON = JSON.stringify($scope.memberObj, null, "  ")

          $scope.save = ->
            result = getMemberObj($scope.newMember)
            # fix timezone offset
            if result.birthDate && result.birthDate instanceof Date
              result.birthDate.setHours(0)
              result.birthDate = new Date(result.birthDate.getTime() + Math.abs(result.birthDate.getTimezoneOffset()) * 60000)
            if result.angelDate && result.angelDate instanceof Date
              result.angelDate.setHours(0)
              result.angelDate = new Date(result.angelDate.getTime() + Math.abs(result.angelDate.getTimezoneOffset()) * 60000)
            $modalInstance.close(result)

          $scope.cancel = ->
            $modalInstance.dismiss('cancel')
          setTimeout( (() -> angular.element('#full-name-input').trigger('focus')), 100 )

      .result.then (member) ->
        if editMode
          index = _.findIndex $scope.members, (memb) ->
            return memb._id == member._id
          $scope.members[index] = member
          $core.$members.save(member).then ->
            alerts.push({type: "warning", msg: "Обновлено!"})
        else
          $scope.members.push(member)
          $core.$members.create(member).then (d) ->
            member._id = d._id
            alerts.push({type: "success", msg: "Добавлено!"})
      , ->
        console.log "Modal dismissed"
