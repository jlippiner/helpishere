$(document).ready(function(){
    togglePName(true);

    if ($("#profile_location").val()=='United States') {
        $('#zipcode_div').show();
    }
    
    if ($("input[@name='profile[how_affected]']:checked").val()=='Caregiver') {
         $('#caregiver').show();
    } else {$('#caregiver').hide();}

    function togglePName(state) {
        if ($("#profile_disease_id").val()==''||$("input[@name='profile[how_affected]']:checked").val()==undefined) return false;

        $('#divPName_label').show();

        if($('#profile_name').val()!='')
            newval = $('#profile_name').val();
        else
            newval = $("#profile_disease_id option:selected").text() + ' - ' + $("input[@name='profile[how_affected]']:checked").val();

        if (state) {
            $('#profile_name').attr("value",newval).hide();
            $('#divPName').html(newval).show();
        } else {
            $('#divPName').toggle();
            $('#profile_name').attr("value",newval).show().focus();
        }
    }

    $('#divPName').mouseover(function(){
        $(this).css('background','#cfc');
        $(this).css('cursor','pointer');
    }).mouseout(function(){
        $(this).css('background','#fff');
    })

    $('#divPName').click(function(){
        togglePName(false)
    })

    $('#profile_name').blur(function(){
        togglePName(true)
    })

    $('#profile_disease_id').change(function(){
        togglePName(true)
    })

    $("input[@name='profile[how_affected]']").change(function()
    {
        togglePName(true)

        switch ($(this).val())
        {
            case 'Caregiver':
                $('#caregiver').show().highlight(3000);
                break;
            default:
                $('#caregiver').hide();
                $('#profile_affected_age').attr("value","");
                $('#profile_affected_relationship').attr("value","");
        }
    });

    $("#profile_location").change(function(){
        if ($(this).val()=='United States') {
            $('#zipcode_div').show().highlight(3000);
            $('#profile_zipcode').focus();
        }
        else {
            $('#zipcode_div').hide();
            $('#profile_zipcode').attr("value","");
        }
    });
});