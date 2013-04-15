// Keep this baby small!
$(document).ready(function(){

  /*  General JQuery Extensions
  ---------------------------------------------------------------------*/
  // Onclick event to toggle between two functions.
  //    example:
  //       $('some-elem').clickToggle(
  //         function(){ alert('on');},
  //         function(){ alert('off');}
  //       );
  (function($) {
      $.fn.clickToggle = function(func1, func2) {
          var funcs = [func1, func2];
          this.data('toggleclicked', 0);
          this.click(function(e) {
              e.preventDefault();
              var data = $(this).data();
              var tc = data.toggleclicked;
              $.proxy(funcs[tc], this)();
              data.toggleclicked = (tc + 1) % 2;
          });
          return this;
      };
  }(jQuery));



  /*  Sidebar Flexible Height (TODO: check if this is even necessary...)
  ---------------------------------------------------------------------*/
  setSidebarHeight();

  window.onresize = function(e) {
    setSidebarHeight();
  }

  function setSidebarHeight() {
    var layout_cols = $('.layout-col'),
        maxHeight = Math.max.apply(
    Math, layout_cols.map(function() {
        return $(this).height();
    }).get());
    // Find which is taller: the window or the tallest layout column
    maxHeight = Math.max(maxHeight, $(window).height())
    $('#global-sidebar').height(maxHeight);
  }


  /*  Toggle hidden info on content.
  ---------------------------------------------------------------------*/
  var hidden_info = {};
  hidden_info.wrap = $('.more-info');
  hidden_info.toggler = hidden_info.wrap.find('a.more-info-toggle');
  //hidden_info.info_content = hidden_info.toggler.next('.more-info-content')

  hidden_info.toggler.css('display','block');
  $('.more-info-content').hide();
  hidden_info.toggler.clickToggle(
    function()
    {
      $(this).parent('.more-info').addClass('opened-info');
      $(this).next('.more-info-content').slideDown(500);
    },
    function()
    {
      $(this).parent('.more-info').removeClass('opened-info');
      $(this).next('.more-info-content').slideUp(500);
     }
  );
});
