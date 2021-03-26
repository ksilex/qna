// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
require("jquery")
require("@nathanvda/cocoon")
import * as bootstrap from 'bootstrap'
import "../stylesheets/application"
import "scripts/gist_formatter"
import "scripts/401-handler"
import "scripts/votes"

// jQuery.fn.smoothRemove = function(speed){
//   $(this).fadeOut(speed,function(){
//     var storeElement = this
//     $(this).remove()
//     if ($(storeElement).parent().children().length == 0) {
//       console.log($(storeElement).parent().html())
//       $(storeElement).parent().remove()
//     }
//   })
// }
document.addEventListener("DOMContentLoaded", function(event) {
  var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  })

  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

  $('.question').on( "click", '[data-association="reward"]', function() {
    $(this).hide();
  });
});

Rails.start()
Turbolinks.start()
ActiveStorage.start()
