// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {

    jQuery.fn.showFlash = function() {
        log(this.selector)
        $(this.selector).show('normal').fadeTo(5000, 1).fadeOut(2000)
    }

    $('#flash_messages').showFlash();

    jQuery.flash = {
        notice: function(message) {
            $('#flash_messages').html(message).addClass('notice').showFlash();
        },
        message: function(message) {
            $('#flash_messages').html(message).addClass('message').showFlash();
        },
        warning: function(message) {
            $('#flash_messages').html(message).addClass('warning').showFlash();
        },
        error: function(message) {
            log('error: ' + message)
            $('#flash_messages').html(message).addClass('error').showFlash();
        }
    }

    var options = {
        success:  showResponse
    };

    $('form[rel*=remote]').ajaxForm(options);
    $('form[rel*=remote]').ajaxSubmit();

    $('a[rel*=facebox]').facebox()

    $('a[rel*=facebox_close]').facebox().click(function(){
        $('#faceBoxClose').show();
    })

    
    $(document).bind('reveal.facebox', function() {        
        $('#faceBoxClose').hide();
    })

    $('a[rel*=toggle]').bind('click', function(){
        var el = this;
        
        $('a[rel*=toggle]').each(function(){
            if (this.id!=el.id)
                $(this.id).hide();
        })

        $(this.id).toggle();
        return false;
    })

    $('a[rel*=toggle]').each(function(){
        $(this.id).hide();
    })

    $("label[rel*=checkit]").click(function(){
        cb = $(this).prev();
        $(cb).attr('checked', !$(cb).attr('checked'))
    })
      
});

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
        window.status = message;
    }
}

// Join Script

function showResponse(responseText, statusText)  {
    log(statusText + ': ' + responseText);
    if(statusText=='success'&&responseText!='save failed'){
        jQuery(document).trigger('close.facebox');
        eval(responseText);
    }
}

$(document).ready(function() {
    var options = {
        success:  showResponse
    };

  
    $('#facebox #join_form').livequery(function() {        
        $(this).submit(function(){

            log('submitted join form')            
            $(this).validate({
                rules: {
                    'user[name]': "required",
                    'user[nickname]': {
                        required: true,
                        minlength: 2,
                        remote: "/user/remote/nickname"
                    },
                    'user[password]': {
                        required: true,
                        minlength: 5
                    },
                    'password_confirm[]': {
                        required: true,
                        minlength: 5,
                        equalTo: "#facebox #user_password"
                    },
                    'user[email]': {
                        required: true,
                        email: true,
                        remote: "/user/remote/email"
                    }
                },
                messages: {
                    'user[name]': "Enter your firstname",
                    'user[nickname]': {
                        required: "Enter a username",
                        minlength: jQuery.format("Enter at least {0} characters"),
                        remote: jQuery.format("{0} is already in use")
                    },
                    'user[password]': {
                        required: "Provide a password",
                        rangelength: jQuery.format("Enter at least {0} characters")
                    },
                    'password_confirm[]': {
                        required: "Repeat your password",
                        minlength: jQuery.format("Enter at least {0} characters"),
                        equalTo: "Enter the same password as above"
                    },
                    'user[email]': {
                        required: "Please enter a valid email address",
                        minlength: "Please enter a valid email address",
                        remote: jQuery.format("{0} is already in use")
                    }
                },
                // the errorPlacement has to take the table layout into account
                errorPlacement: function(error, element) {
                    if ( element.is(":radio") )
                        error.appendTo( element.parent().next().next() );
                    else if ( element.is(":checkbox") )
                        error.appendTo ( element.next() );
                    else
                        error.appendTo( element.parent().next() );
                },
                // set this class to error-labels to indicate valid fields
                success: function(label) {
                    // set &nbsp; as text for IE
                    label.html("&nbsp;").addClass("checked");
                }
            }).form();

            if ($(this).valid()) {
                $(this).ajaxSubmit(options);                
            }

            return false; //$('#facebox #form_details').valid();
        })
    });

});