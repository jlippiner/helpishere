/* 
 * Search page specific javascripts get put in here.
 */

function step3_zip_show() {
    $(document).ready(function() {
        $('#step3_zip_show').click();
        log('step3_zip_show')
    });
}

function s() {
    alert('welcome')
}

$(document).ready(function() {
    var options = {
        success:  showResponse
    };

    $('#facebox #join_form').livequery(function() {
        $(this).ajaxForm(options);

        // validate signup form on keyup and submit
        var validator = $(this).validate({
            rules: {
                'user[name]': "required",
                'user[nickname]': {
                    required: true,
                    minlength: 2,
                    remote: "/search/remote_handler/a"
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
                    remote: "/search/remote_handler/a"
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
                $(this).ajaxSubmit();
            },
            // set this class to error-labels to indicate valid fields
            success: function(label) {
                // set &nbsp; as text for IE
                label.html("&nbsp;").addClass("checked");
            },
            invalidHandler: function() {
                var errors = validator.numberOfInvalids();
                if (errors) {
                    var message = errors == 1
                    ? 'You missed 1 field. It has been highlighted'
                    : 'You missed ' + errors + ' fields. They have been highlighted';
                //alert(message);
                } else {
                    $("div.error").hide();
                }
            }

        });
    });
});
