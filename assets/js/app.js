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

    // Show/Hide Posts
    var toggleLinks = document.getElementsByClassName('show-hide-toggle')
    $.each(toggleLinks, function(index, toggleLink){
      toggleLink.addEventListener('click', function(e) {
	var postBody = document.getElementById(e.target.getAttribute('data-toggle-id'))
	if (postBody.style.display === 'none') {
          postBody.style.display = 'block'
	  this.innerHTML = this.getAttribute('data-hide-text')
	} else {
          postBody.style.display = 'none'
	  this.innerHTML = this.getAttribute('data-show-text')
	}
      }, false)
    })

    // Tag Filter
    var tagSelectors = document.getElementsByClassName("tag-select")
    $.each(tagSelectors, function(tagIndex, link) {
      link.addEventListener('click', function(){
	var tag = link.getAttribute('data-tag-name')
	var postBodys = document.getElementsByClassName("tag-selectable")
	$.each(postBodys, function(postIndex, postBody){
	  if(tag == 'all' || postBody.classList.contains('tag-' + tag)) {
	    postBody.style.display = 'block'
	  } else {
	    postBody.style.display = 'none'
	  }
	})

	$.each(tagSelectors, function(innerTagIndex, innerLink){
	  if(innerLink.getAttribute('data-tag-name') == tag) {
	    innerLink.classList.add('active')
	  } else {
	    innerLink.classList.remove('active')
	  }
	})
      })
    })

    // Text Area Auto-Resize
    $('textarea').each(function() {
      this.setAttribute('style', `height:${this.scrollHeight}px;overflow-y:hidden;`)
    }).on('input', function() {
      this.style.height = 'auto'
      this.style.height = this.scrollHeight + 'px'
    })    
  }
}
