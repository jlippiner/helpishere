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
        log(responseText);
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

// Join Script

function join_hih_complete() {
    alert('welcome')
}

$(document).ready(function() {
    var options = {
        success:  showResponse
    };

    $('#facebox #join_form').livequery(function() {
        $(this).ajaxForm(options);
       
        // validate signup form on keyup and submit
        $(this).validate({
            rules: {
                'user[name]': "required",
                'user[nickname]': {
                    required: true,
                    minlength: 2,
                    remote: "/user/remote_handler"
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
                    remote: "/user/remote_handler"
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
            // specifying a submitHandler prevents the default submit, good for the demo
            submitHandler: function() {
                
            },
            // set this class to error-labels to indicate valid fields
            success: function(label) {
                // set &nbsp; as text for IE
                label.html("&nbsp;").addClass("checked");
            },
            invalidHandler: function() {
              return false;
            }

        });
    });
});