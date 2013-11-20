
jQuery(document).ready(function($) {
    //$('#nav-main').scrollspy()
    // Localscrolling 
    $('#nav-main, .brand').localScroll();
     $('#news, .container').localScroll();
    $("a[rel^='prettyPhoto']").prettyPhoto();
    
    $(".loginlink").click(function(){
       $(".loginlinks").toggle();
       $(".loginbar").toggle();
    });
    
    $("#login-cancel").click(function(){
       $(".loginlinks").toggle();
       $(".loginbar").toggle();
    });
    
    $("#login").validate();
});
