var app = app || {};
app.forecast = {};
app.forecast.id = app.tools.getParam("id");

$(document).ready(function(){
  
    app.forecast.initialize();    
});

app.forecast.initialize = function(){
  $("#btnSaveForecast").click(function(){
      app.forecast.save();
  });
};

app.forecast.save = function(){
    var save = true;
    var info = [];
    
    $(".data-forecast").each(function(i, j){
        var texts = $(j).find("input[type=text]");
        var contender1 = $(texts[0]);
        var contender2 = $(texts[1]);
        
        var valid = contender1.val() && contender2.val() ? true : false;
        
        if(!valid) 
        {
            $(j).addClass("error");
            bootbox.alert("Please check the fields, you should have two results for each match");
            save = false;
            return;
        }
        
        info[i] = {"idmatch": $(j).attr("id"),"contenders":[{"id":contender1.attr("contender"), "value": contender1.val()},{"id":contender2.attr("contender"), "value": contender2.val()}]}
        
        
    });
    
    if(save)
    {
        $.ajax({
            url: "/tournaments/save-forecast",
            data:{
                id: app.forecast.id,
                data: JSON.stringify(info)
            },
            dataType: "json"
        }).done(function( data ) {
            if ( console && console.log ) {
                console.log( "Sample of data:", data);
            }
           
            bootbox.alert(data);
            
        }).fail(function(err, textStatus) {
            bootbox.alert(err.responseText);
        });
    }
};