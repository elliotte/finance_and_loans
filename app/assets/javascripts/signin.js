function onSignInCallback(authResult) {

  if (authResult['error']) {
        // The user is not signed in.
        if (authResult['error'] == "immediate_failed") {
              console.log('NO APP ACCESS')
            }
        if (authResult['error'] == "user_signed_out") {
            helper.displaySignedOutModal();
            console.log('SignedOut googleCallBack')
            console.log(authResult['status'])
            // catch for legacy signin..
            if (helper.authResult) {
                helper.disconnectUser();
            }// end of legacy token check and revoke
        }
  }// END OF authError CATCH
  // else if(authResult.status.method=="PROMPT") {
  //   helper.loadServerSideAuth(authResult);
  // }
  else
    helper.loadServerSideAuth(authResult);
}

var signIn = (function() {

  return {
    authWindows: function() {
      $('#action-auth-sign-in').slideUp();
      $('#windows-signin-button').toggle( "slide" );
    },
    authGoogle: function() {
      $('#action-auth-sign-in').slideUp();
      $('#google-signin-button').toggle( "slide" );
      // TO ADD CHECK IS DISPLAYED IN BROWSER TO CATCH AUTH HAS RENDERED AND POSSIBLE FOR USER
    },
  }

})();

var helper = (function() {
  
  var authResult = undefined;
  var googleApi = undefined;

  return {

    loadServerSideAuth: function(authResult) {
      if (authResult['access_token']) {
        // The user is signed in
        this.authResult = authResult;
        // After loading the Google+ API, set the profile data from Google+ to load after serverSide connection.
        this.googleApi = gapi;
        //helper.loadLandingAssets();
        
        helper.connectServer();
        
        // Put the object into storage
        localStorage.setItem('accessToken', authResult.access_token);
        // Retrieve the object from storage
        

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
            dataType: 'json',
            url: '/welcome/connect?state=' + $("#state").text(),
            contentType: 'application/octet-stream; charset=utf-8',
            success: function(result) {
              //console.log(result);
              path = window.location.href
              reRoute = path + 'welcome/auth_landing'
              console.log('success and ' + result)
              if ( result == 'New connection made' ) {
                  //helper.loadLandingAssets();
                  //helper.loadGPlus();
                  // TO ADD SOME LOCALSTORAGE CACHE
                  window.location.href = reRoute

                } else if ( result == 'The client state does not match the server state.' ) {
                  console.log('success BUT' + result )
                  window.location.reload();
                } else if (result == 'Invalid Credentials, app session cleared') {
                  window.location.reload();
                } else {
                  // to add connection validated and cache trans
                  //helper.loadLandingAssets();
                  //helper.loadGPlus();
                  window.location.href = reRoute
                  console.log('success AND using already established server side connection, message being:');
              };
            },
            error: function(err) {
              if ( err.responseText.indexOf('Faraday::SSLError') > -1) {
                html = '<p>' + 'BROWSER TOKEN EXPIRED:  You need to FULLY CLOSE your browser and re-authenticate your SIGN-IN' + '</p>' 
                $('#bg-screen-for-modal').addClass('open')
                $('#bg-screen-for-modal').find('section').empty().append(html)
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

    // loadLandingAssets: function() {
    //     //helper.loadWelcomeLedgers();
    //     //helper.loadWelcomeReports();
    //     // $('#gConnect').hide();
    //     // $("#office365_connect").hide();
    //     // $('#authOps').show();
    //     // $('.modal-close').trigger('click')
    //     // $(".modal-state:checked").prop("checked", false).change();
    //     //helper.loadGPlus();
    //     // $('#disconnect').on('click', function(e) {
    //     //     e.preventDefault();
    //     //     helper.disconnectUser();
    //     //     helper.disconnectServer();
    //     // });
    // },

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
                alert(error)
              //helper.disconnectServer();
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
        $('#bg-screen-for-modal').addClass('open')
        $('#bg-screen-for-modal').find('section').empty().append(html)
        $('#bg-screen-for-modal').find('section').append(image)


    },

    disconnectUser: function() {
        // NEED TO SPLIT INTO CHECK BACK END AND FRONT END
        // var access_token = this.authResult.access_token;
        var access_token = localStorage.getItem('accessToken');
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
          localStorage.clear();
          console.log('revoke response: ' + result);
          helper.displaySignedOutModal();
        },
        error: function(e) {
          localStorage.clear();
          helper.displayErrorModal();
        }
      });
    },

    displayErrorModal: function() {
      
      $('#bg-screen-for-modal').addClass('open')
      html = '<p>' + 'Error, please refresh the page ' +  '<a href="/" data-no-turbolinks=true>'  + 'REFRESH' + '</a>' + '</p>' + '<p>' + 'We check a lot of authenication steps on signing in, please be patient.' + '</p>'
      $('#bg-screen-for-modal').find('section').empty().append(html)

    },

    displaySignedOutModal: function() {

      $('#bg-screen-for-modal').addClass('open')
       
      html = '<p>' + 'Signed Out, you need to refresh the page to sign back in ' +  '<a href="/" data-no-turbolinks=true>'  + 'REFRESH' + '</a>' + '</p>'
      $('#bg-screen-for-modal').find('section').empty().append(html)

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





