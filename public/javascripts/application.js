// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
    // bind 'myForm' and provide a simple callback function
    var options = {
        success:  showResponse
    };

    $('form[rel*=remote]').ajaxForm(options);
    $('form[rel*=remote]').ajaxSubmit();

    $('a[rel*=facebox]').facebox()

    $(document).bind('reveal.facebox', function() {  
        $('#faceBoxClose').hide();
    })

});

function showResponse(responseText, statusText)  {
    if(statusText=='success'){
        eval(responseText);
    }
}

function redirect(url) {
    log(url);
    document.location=url;
}

function validate(formData) {
    log(formData.length);
    log(formData.id);
    for (var i=0; i < formData.length; i++) {
        log(formData[i].value);
        if (!formData[i].value) {
            return false;
        }
    }
    return true;
}

function log(message, type) {
    if(type == null) { 
        type = "log"
    }
    if(typeof(console) != "undefined" ) {
        console[type](message);
    } else {
        alert(message);
    }
}