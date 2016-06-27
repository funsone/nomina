// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery2
//= require jquery_ujs
//= require bootstrap-sprockets
//= require cocoon
//= require codemirror
//= require codemirror/modes/ruby
//= require_tree .


$(document).ready(function() {


      $('#main-menu').metisMenu();
      var $this = $('#main-menu'),
        resizeTimer,
        self = this;
      var initCollapse = function(el) {
        if ($(window).width() >= 768) {
          this.find('li').has('ul').children('a').off('click');
        }
      };
      $(window).resize(function() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(self.initCollapse($this), 250);
      });
      $.contextMenu({
           selector: '*:not(input)',
           callback: function(key, options) {
              if(key=="acercade")
              {
                $("#acercade").modal('show');
              }
           },
           items: {

               "acercade": {name: "FUNSONE NÓMINA", icon: "fa-info-circle"},
               "sep1": "---------",
               "quit": {name: "Quitar", icon: function(){
                   return 'context-menu-icon context-menu-icon-quit';
               }}
           }
       });
      $.contextMenu({
           selector: 'input',
           callback: function(key, options) {

if(key=="paste"){alert("Por favor úse CTRL+v"); return 'context-menu-icon context-menu-icon-quit';}
  var copyTextarea = document.querySelector("#"+options.$trigger.attr("id"));
  //copyTextarea.select()

  try {

    var successful = document.execCommand(key);

    var msg = successful ? 'successful' : 'unsuccessful';
    console.log(key+' text command was ' + msg);
    copyTextarea.blur();
  } catch (err) {
    console.log('Oops, unable to copy');
  }


           },
           items: {

               "cut": {name: "Cortar", icon: "fa-cut"},
              "copy": {name: "Copiar", icon: "fa-copy"},
               "paste": {name: "Pegar", icon: "fa-paste"},
               "delete": {name: "Borrar", icon: "fa-trash"},
               "sep1": "---------",
               "undo": {name: "Deshacer", icon: "fa-undo"},
               "redo": {name: "Rehacer", icon: "fa-repeat"},
               "sep2": "---------",
               "quit": {name: "Quitar", icon: function(){
                   return 'context-menu-icon context-menu-icon-quit';
               }}
           }
       });



});
