var app = app || {};
app.tournament = {};
app.tournament.id = app.tools.getParam("id");

$(document).ready(function(){
    app.tournament.initialize();
});

app.tournament.initialize = function(){
    
    $("#create-form").validate(); 
    
    $(".pagelink").click(function(){
       $("#hdPage").val($(this).attr("page"));
       $("#search-form").submit();
    });
    
    $(".linkOrder").click(function(){
       var _this = $(this);
       var order = _this.hasClass("ascending") ? "descending" : "ascending";
       var field = _this.attr("field")
       $("#sortField").val(field);
       $("#sortOrder").val(order);
       $("#search-form").submit();
    });
    
    app.tournament.validateAddUser();
    
    $("#btnAddUser").click(function(){
        if($('#add-form').valid())
        {
            if($('#inviteUser').val())
                app.tournament.invite($("#inviteUser").val());
            else
                app.tournament.addUser($('#addUser').val());
            
        }
    });
    
    var options = {
        data: {id: app.tournament.id},
        beforeSend: function()
        {
            $("#progress").show();
            //clear everything
            $("#bar").width('0%');
            $("#message").html("");
            $("#percent").html("0%");
        
        },
        beforeSubmit: function() {
            return $('#contender-form').validate().form();
        },
        uploadProgress: function(event, position, total, percentComplete)
        {
            $("#bar").width(percentComplete+'%');
            $("#percent").html(percentComplete+'%');
     
        },
        success: function()
        {
            $("#bar").width('100%');
            $("#percent").html('100%');
            $("#contender-form").resetForm();
            $("#progress").delay(5000).fadeOut(400);
            $("#message").delay(5000).fadeOut(400);
     
        },
        complete: function(response)
        {
            $("#message").html("<font color='green'>"+response.responseText+"</font>");
        },
        error: function()
        {
            $("#message").html("<font color='red'> ERROR: unable to upload files</font>");
        }
    }
    
    $("#contender-form").ajaxForm(options);
    
    /**** Add contender ***/
    $("#addContenderModal").dialog({ 
        modal:true, 
        autoOpen: false,
        height: 300,
        width: 450,
        modal: true
    });
    
    $(".linkAddContender").click(function(){
         $( "#autoContender" ).val("");
         $("#addContenderModal").dialog("open");
    });

     $( "#autoContender" ).autocomplete({
        source: "/contender/autocomplete",
        minLength: 3,
        select: function( event, ui ) {
            ui.item ? app.tournament.saveContender(ui.item) : bootbox.alert("None item selected"); 
        }
    });

    /*****End Add Contender ******/
    
    /********Add Match******************/
    $("#addMatchModal").dialog({ 
        modal:true, 
        autoOpen: false,
        height: 500,
        width: 650,
        modal: true
    });
    
    $(".linkAddMatch").click(function(){
         $("#addMatchModal").dialog("open");
    });
    
    $("#btnMatchSave").click(function(){
       if($('#matchAdd').valid())
       {
            var $contender1 = $("#contender1").val()
            var $contender2 = $("#contender2").val()
            var $date = $("#matchDate").val()
            app.tournament.addMatch($contender1, $contender2, $date);
       }
    });
    
    $( "#matchDate" ).datepicker({ dateFormat: "yy-mm-dd" });
    /********End Add Match**************/
};

app.tournament.addUser = function($user){
    $.ajax({
            url: "/tournaments/add-user",
            data:{
                id: app.tournament.id,
                username: $user
            }
        }).done(function( data ) {
            if ( console && console.log ) {
                console.log( "Sample of data:", data);
            }
            
            bootbox.alert(data);
        }).fail(function(err, textStatus) {
            bootbox.alert(err.responseText);
        });
};

app.tournament.invite = function($email){
    $.ajax({
            url: "/tournaments/invite",
            data:{
                id: app.tournament.id,
                email: $email
            }
        }).done(function( data ) {
            if ( console && console.log ) {
                console.log( "Sample of data:", data);
            }
            
            bootbox.alert(data);
        }).fail(function(err, textStatus) {
            bootbox.alert(err.responseText);
        });
};

app.tournament.validateAddUser = function() {
    
    $('#add-form').validate({
          rules: {
                addUser: {
                      required: function(element) {
                            return $('#inviteUser').val() == '';
                      }
                },
                inviteUser: {
                      required: function(element) {
                            return $('#addUser').val() == '';
                      }
                }
          },
          messages: {
                addUser: {
                      required: 'Please fill at least one field.'
                },
                inviteUser: {
                      required: 'Please fill at least one field.'
                }
          }
    });
};

app.tournament.saveContender = function(item){
    $.ajax({
        url: "/tournaments/add-contender",
        data:{
            id: app.tournament.id,
            uri: item.id
        }
    }).done(function( data ) {
        if ( console && console.log ) {
            console.log( "Sample of data:", data);
        }
        $( "#autoContender" ).val("");
        bootbox.alert(data);
        
    }).fail(function(err, textStatus) {
        bootbox.alert(err.responseText);
    });
};

app.tournament.addMatch = function($contender1, $contender2, $date){
    $.ajax({
        url: "/tournaments/add-match",
        data:{
            id: app.tournament.id,
            contender1: $contender1,
            contender2: $contender2,
            date: $date
        },
        dataType: "json"
    }).done(function( data ) {
        if ( console && console.log ) {
            console.log( "Sample of data:", data);
        }
        $('#matchAdd').resetForm();
        bootbox.alert(data.info.message);
        
        $("#tbMatches").find("tbody:last").after("<tr><td>"+data.info.name+"</td><td>"+data.info.date+"</td><td></td></tr>");
        
    }).fail(function(err, textStatus) {
        bootbox.alert(err.responseText);
    });
};

