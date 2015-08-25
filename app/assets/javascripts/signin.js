function onSignInCallback(authResult) {

  if (authResult['error']) {
        // The user is not signed in.
        if (authResult['error'] == "immediate_failed") {
              console.log('NO APP ACCESS')
            }
        if (authResult['error'] == "user_signed_out") {
            helper.displaySignedOutModal();

            console.log('SignedOut googleCa llBack')
            console.log(authResult['status'])
            // catch for legacy signin..
            if (helper.authResult) {
                helper.disconnectUser();
            }// end of legacy token check and revoke
        }
  }// END OF authError CATCH  
  else {
    helper.loadServerSideAuth(authResult);
  }
}

var helper = (function() {
  
  var authResult = undefined;
  var googleApi = undefined;

  return {

    loadServerSideAuth: function(authResult) {
      
      $('#modal-loading-landing').trigger('click')
      
      if (authResult['access_token']) {
        // The user is signed in
        this.authResult = authResult;
        // After loading the Google+ API, set the profile data from Google+ to load after serverSide connection.
        this.googleApi = gapi;
        helper.connectServer();

      } else if (authResult['error']) {
        // SHOULD NEVER GET HERE
        helper.displayErrorModal();
        console.log('There was an error: ' + authResult['error']);
      }
      console.log('authResult', authResult);
    },

    connectServer: function() {
      //console.log(this.authResult.code);
          $.ajax({
            type: 'POST',
            url: '/welcome/connect?state=' + $("#state").text(),
            contentType: 'application/octet-stream; charset=utf-8',
            success: function(result) {
              //console.log(result);
              if ( result == 'New connection made' ) {
                  helper.loadLandingAssets();
                  console.log('success and ' + result)
                } else if ( result == 'The client state does not match the server state.' ) {
                  console.log('success BUT' + result )
                  window.location.reload();
                } else if (result == 'Invalid Credentials, app session cleared') {
                  window.location.reload();
                } else {
                  // to add connection validated and cache trans
                  helper.loadLandingAssets();
                  console.log('success AND using already established server side connection, message being:');
              };
            },
            error: function(err) {
              if ( err.responseText.indexOf('Faraday::SSLError') > -1) {
                html = '<p>' + 'BROWSER TOKEN EXPIRED:  You need to FULLY CLOSE your browser and re-authenticate your SIGN-IN' + '</p>' 
                $('.modal-close').trigger('click')
                $(".modal-state:checked").prop("checked", false).change();
                $('#empty-modal-body-append').empty();
                $('#empty-modal-body-append').append(html)
                $('#modal-empty').trigger('click')
              } else {
                helper.displayErrorModal();
                helper.disconnectServer();
              }
            },
            processData: false,
            data: this.authResult.code + ',' + this.authResult.id_token + ',' + this.authResult.access_token
          })
      // END OF POST
    },

    loadLandingAssets: function() {

        helper.loadWelcomeLedgers();
        helper.loadWelcomeReports();
        $('#gConnect').hide();
        $('#authOps').show();
        $('.modal-close').trigger('click')
        $(".modal-state:checked").prop("checked", false).change();
        helper.loadGPlus();

        $('#disconnect').on('click', function(e) {
            e.preventDefault();
            helper.disconnectUser();
            helper.disconnectServer();
        });
    },

    loadWelcomeLedgers: function() {
      $.ajax({
        type: 'GET',
        url: '/ledgers/last_user_ledgers',
        contentType: 'application/octet-stream; charset=utf-8',
        success: function(result) {
          console.log('welcomeLedgers route hit');
          //console.log(result);
          //helper.appendDrive(result);
        },
        processData: false
      });
    },

    loadWelcomeReports: function() {
      $.ajax({
        type: 'GET',
        url: '/reports/last_user_reports',
        contentType: 'application/octet-stream; charset=utf-8',
        success: function(result) {
          console.log('welcomeReports route hit');
          //console.log(result);
          //helper.appendDrive(result);
        },
        processData: false
      });
    },

    loadGPlus: function() {
      helper.googleApi.client.load('plus', 'v1').then(function() {
            
            var request = gapi.client.plus.people.get({
                'userId': 'me'});
            request.then(function(resp) {
                helper.appendProfile(resp);
            }, function(error){
              helper.disconnectServer();
              window.location.reload();
            });

            var people_request = gapi.client.plus.people.list({
                'userId' : 'me', 'collection' : 'visible'
            });
            people_request.execute(function(resp) {
                localStorage.setItem('friends', JSON.stringify(resp));
            });
      });

    },

    appendProfile: function(resp) {

        var image = document.createElement('img');
        image.src = resp.result.image.url;
        
        html = 'Welcome ' + '<span style="color: #eee;">' + resp.result.displayName + '</span>'
        $('#welcome-name-append').empty().append(html)
        $('#welcome-profile-append').empty().append(image)

    },

    disconnectUser: function() {
        // NEED TO SPLIT INTO CHECK BACK END AND FRONT END
        var access_token = this.authResult.access_token;
        var url = 'https://accounts.google.com/o/oauth2/revoke?token=' + access_token;
        try {
            var xhr = new XMLHttpRequest();
            xhr.open('GET', url, false);
            xhr.onload = function(response) {
                if (this.status == 200) {
                    // success
                    console.log('FRONTEND token Revoke')
                    console.log("User disconnected");
                    helper.displaySignedOutModal();
                }
            }
            xhr.send();
        } catch (error) {
           helper.displayErrorModal();
        }
    }, 

    disconnectServer: function() {
      // Revoke the server tokens
      $.ajax({
        type: 'POST',
        url: '/welcome/disconnect',
        async: false,
        success: function(result) {
          console.log('revoke response: ' + result);
          helper.displaySignedOutModal();
        },
        error: function(e) {
          helper.displayErrorModal();
        }
      });
    },

    displayErrorModal: function() {

      $('.modal-close').trigger('click')
      $(".modal-state:checked").prop("checked", false).change();

      $('#empty-modal-body-append').empty();
      $('#modal-empty').trigger('click')
        html = '<p>' + 'Error, please refresh the page ' +  '<a href="/" data-no-turbolinks=true>'  + 'REFRESH' + '</a>' + '</p>' + '<p>' + 'We check a lot of authenication steps on signing in, please be patient.' + '</p>'
      $('#empty-modal-body-append').append(html)

    },

    displaySignedOutModal: function() {

      $('#empty-modal-body-append').empty();
      $('#modal-empty').trigger('click')
        html = '<p>' + 'Signed Out, you need to refresh the page to sign back in ' +  '<a href="/" data-no-turbolinks=true>'  + 'REFRESH' + '</a>' + '</p>'
      $('#empty-modal-body-append').append(html)

    },

  };

})();

// NOT USED?
// function updateFriendsList(friendsList){
//   localStorage.setItem('friends', JSON.stringify(friendsList));
// }

// function updateFiles(files) {
//   localStorage.setItem('googleFiles', JSON.stringify(files))
// }

// function clearFriendsList(){
//   localStorage.removeItem('friends');
// }





