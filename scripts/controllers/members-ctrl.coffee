angular.module('appLibs').directive 'modalWindow', ->
  return {
    restrict: 'EA'
    link: (scope, element) ->
      console.log scope, element
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
      console.log("onDelete", index, member)
      if confirm("Delete #{member.fullName}?")
        _.remove $scope.members, (memb) -> memb._id == member._id
        $core.$members.delete(member._id).then ->
          alerts.push({type: "danger", msg: "Deleted!"})

    $scope.onEditOrAdd = (index, memb) ->
      editMode = if memb then true else false
      console.log("onEditOrAdd", index, memb)

      modalInstance = $modal.open
        templateUrl: 'myModalContent.html'
        controller: ($scope, $modalInstance) ->

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
               active: yes }

          getMemberObj = (newMember) ->
            if editMode
              member = angular.copy(memb)
            else
              member = { created : new Date }

            member.fullName ?= filterText(newMember.fullName).trim()
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
            member.phone = phoneHelpers.formatPhoneRaw(newMember.phone)
            member.active = !!newMember.active
            member.updated = new Date

            return member

          $scope.memberJSON = JSON.stringify(getMemberObj($scope.newMember), null, "  ")

          $scope.$watchCollection "newMember", ->
            $scope.memberObj = getMemberObj($scope.newMember)
            $scope.memberJSON = JSON.stringify($scope.memberObj, null, "  ")

          $scope.save = ->
            result = getMemberObj($scope.newMember)
            console.log "SAVE MEMBER", result
            $modalInstance.close(result)

          $scope.cancel = ->
            $modalInstance.dismiss('cancel') 

      .result.then (member) ->
        if editMode
          index = _.findIndex $scope.members, (memb) ->
            return memb._id == member._id
          console.log("CHECK", index, $scope.members, $scope.members[index], member)
          $scope.members[index] = member
          $core.$members.save(member).then ->
            alerts.push({type: "warning", msg: "updated!"})
        else
          $scope.members.push(member)
          $core.$members.create(member).then (d) ->
            member._id = d._id
            alerts.push({type: "success", msg: "Added!"})
      , ->
        console.log "Modal dismissed"
