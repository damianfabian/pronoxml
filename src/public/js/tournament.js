$(document).ready(function(){
    $("#create-form").validate(); 
    
    $(".pagelink").click(function(){
       $("#hdPage").val($(this).attr("page"));
       $("#search-form").submit();
    });
});