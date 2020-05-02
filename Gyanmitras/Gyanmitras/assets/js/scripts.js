(function (window, undefined) {
  'use strict';
  $(".bulkShowIn").on('click', function () {
      //alert('manish1')
      $(this).parents('.content-body').find('.bulkOut').addClass('show');
      $(this).parents('.content-body').find('.bulkIn').addClass('hide');
  });
  $(".bulkOutHide").on('click', function () {
      //alert('manish1')
      $(this).parents('.content-body').find('.bulkOut').removeClass('show');
      $(this).parents('.content-body').find('.bulkIn').removeClass('hide');
  });
  var windowHieght = $(window).height();
  $('.dashboardTableScroll').css('height', (windowHieght - 206));
  $('.mainTableHeight').css('height', (windowHieght - 472));
  $('.widthCenter.heightShow').css('height', (windowHieght - 176));
    $('.mapTrackVehicle').css('height', (windowHieght - 154));
    $('.heightShowTrack').css('height', (windowHieght - 116));
    $('.portGeoHeight').css('height', (windowHieght - 174));
    $('#accordionWrap1.tripReport .tripStatus').css('height', (windowHieght - 605));
    $('.viewSpeed .singleTrip').css('height', (windowHieght - 461));
  var silder_index = 1;
  //var silder_length = $("#GyanmitrasSlide img").length;
  var silder_length = $("#GyanmitrasSlide .slideDiv").length;
  var last_image = 5;
  setInterval(function () {
    $(".hide-silde").removeClass("hide-silde");
    $(".first-silde").removeClass("first-silde");
    var prev_img = $("#GyanmitrasSlide .slideDiv[style*='3']");
    //var prev_img = $("#GyanmitrasSlide img[style*='3']");
    $("#GyanmitrasSlide .slideDiv").css("z-index", "1");
    //$("#GyanmitrasSlide img").css("z-index", "1");
    prev_img.css("z-index", "2");
    $("#GyanmitrasSlide .slideDiv").eq(silder_index).css("z-index", "3").removeClass("ActiveImg").addClass("ActiveImg");
    //$("#GyanmitrasSlide img").eq(silder_index).css("z-index", "3").removeClass("ActiveImg").addClass("ActiveImg");
    setTimeout(function () {
      $("#GyanmitrasSlide .slideDiv[style*='1']").removeClass("ActiveImg");
      //$("#GyanmitrasSlide img[style*='1']").removeClass("ActiveImg");
    }, 1500);
    last_image = "" + silder_index;
    silder_index++;
    if (silder_index == silder_length)
      silder_index = 0;
  }, 10000);
    
  //-----Select2-----//
 // $(".select2").select2(); 
    
  //-----Date Picker-----//
    
  //-----dashLeftpinMnu Menu Start-----//
  $(".dashLeftpinMnu").on('click', function () {
    if (!$(this).parents('.content-body').hasClass('full-weight-right')) {
      $(this).parents('.content-body').addClass('full-weight-right');
    } else {
      $(this).parents('.content-body').removeClass('full-weight-right');
    };
    return false;
  });
  //-----dashLeftpinMnu Menu End-----//

  //-----dashRightpinMnu Menu Start-----//
  $(".dashRightpinMnu").on('click', function () {
    if (!$(this).parents('.content-body').hasClass('full-weight-left')) {
      $(this).parents('.content-body').addClass('full-weight-left');
    } else {
      $(this).parents('.content-body').removeClass('full-weight-left');
    };
    return false;
  });
  //-----dashRightpinMnu Menu End-----//
    
	//-----Pin Menu Start-----//
	$(".pinMnu").on('click', function () {
        if (!$(this).parents('.content-body').hasClass('full-right')) {
            $(this).parents('.content-body').addClass('full-right');
            $(this).find('i').addClass('inSide');
        } else {
			$(this).find('i').removeClass('inSide');
            $(this).find('i').addClass('outSide');
            $(this).parents('.content-body').removeClass('full-right');
        };
        return false;
    });
	//-----Pin Menu End-----//
})(window);
