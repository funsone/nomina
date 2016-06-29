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
//= require turbolinks
//= require_tree .

var fun= function (){
  $(function () {
    $('[data-toggle="popover"]').popover();
  });

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

}

document.addEventListener("turbolinks:load",fun)
