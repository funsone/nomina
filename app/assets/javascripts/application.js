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
//= require Chart
//= require_tree .

var fun= function (){

    $('[data-toggle="popover"]').popover();

        $('#main-menu').metisMenu();
        var $this = $('#main-menu'),
          resizeTimer,
          self = this;
        var initCollapse = function(el) {
          if ($(window).width() >= 768) {
          $('#main-menu').find('li').has('ul').children('a').off('click');
          $('#page-wrapper').css("margin-left","260px");
          $(".sidebar-collapse").collapse('show');
        }else {
          $(".sidebar-collapse").collapse('hide');
          $('#page-wrapper').css("margin-left","0px");

        }
        };
        $(window).resize(function() {
          clearTimeout(resizeTimer);
          resizeTimer = setTimeout(initCollapse($this), 250);
        });

}

document.addEventListener("turbolinks:load",fun)
