// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"


export var App = {
  run: function(){
    var toggleLinks = document.getElementsByClassName('show-hide-toggle')

    var i
    for (i = 0; i < toggleLinks.length; i++) {
      toggleLinks[i].addEventListener('click', function(e) {
	var postBody = document.getElementById(e.target.getAttribute('data-toggle-id'))
	var link = document.getElementById(e.target.getAttribute('id'))
	if (postBody.style.display === 'none') {
          postBody.style.display = 'block'
	  link.innerHTML = link.getAttribute('data-hide-text')
	} else {
          postBody.style.display = 'none'
	  link.innerHTML = link.getAttribute('data-show-text')
	}
      }, false)
    }
  }
}
