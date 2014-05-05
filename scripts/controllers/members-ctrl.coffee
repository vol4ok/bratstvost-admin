angular.module('appLibs').directive 'modalWindow', ->
  return {
    restrict: 'EA'
    link: (scope, element) ->
      console.log scope, element
      element.find('.modal-dialog').addClass('modal-lg')
    }

angular.module('appLibs').controller "MembersCtrl", ($scope, $core, $modal, uuid4, phoneHelpers, textHelpers) ->

    {filterText, stripP, FSM} = textHelpers
    mainscope = $scope

    $core.$members.all().then (members) ->
      $scope.members = members

    alerts = $scope.alerts = []

    $scope.onDelete = (index, member) ->
      console.log("onDelete", index, member)
      if confirm("Delete #{member.fullName}?")
        _.remove $scope.members, (memb) -> memb._id == member._id
        $core.$members.delete(member._id).then ->
          alerts.push({type: "danger", msg: "Deleted!"})

    $scope.onEdit = (index, memb) ->
      console.log("onEdit", index, memb)

      modalInstance = $modal.open
        templateUrl: 'myModalContent.html'
        controller: ($scope, $modalInstance) ->

          $scope.newMember = angular.copy(memb)

          # {
          #   fullName: memb.fullName
          #   lastName: memb.lastName
          #   firstName: memb.firstName
          #   middleName: memb.middleName
          #   position: memb.position
          #   male: yes
          #   photoId: ''
          #   phone: ''
          #   email: ''
          #   skype: ''
          #   info: ''
          # }    

          getMemberObj = (newMember) ->
            member = angular.copy(memb)
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
        index = _.findIndex $scope.members, (memb) ->
          return memb._id == member._id
        console.log("CHECK", index, $scope.members, $scope.members[index], member)
        $scope.members[index] = member
        $core.$members.save(member).then ->
          alerts.push({type: "warning", msg: "updated!"})
      , ->
        console.log "Modal dismissed"

    $scope.open = ->

      # $("input[type=checkbox]").on "onclick onmouseover onmouseout", ->
      #   $(this).focus().blur()

      modalInstance = $modal.open
        templateUrl: 'myModalContent.html'
        controller: ($scope, $modalInstance) ->

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
          }            

          getMemberObj = (newMember) ->
            member = {}
            member._id = uuid4.generate()
            member.fullName = filterText(newMember.fullName).trim()
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
            member.created = new Date
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
        $scope.members.push(member)
        $core.$members.create(member).then ->
          alerts.push({type: "success", msg: "Added!"})
      , ->
        console.log "Modal dismissed"