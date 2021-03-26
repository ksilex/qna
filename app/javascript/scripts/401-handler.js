document.addEventListener("turbolinks:load", function() {
  document.body.addEventListener('ajax:error', function(event) {
    var xhr = event.detail[2];
    if (xhr.status == 401) {
      window.location.replace('/users/sign_in')
    }
  })
})
