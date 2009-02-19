// RESOURCE.JS

function content_toggle(div) {
    $('#gMap').hide();
    $('#new_resource').hide();
    $('#contact_content').hide();

    $(div).show()
}

$(document).ready(function(){
    
    // details
    $(".resource_row").livequery('click',function(){
        $('#contact_content').load('/resource/remote/load_contact?id=' + $(this).attr('rel'));
        content_toggle('#contact_content');
    })

    // OPTIONS VIEW
    $('#filter').hide();
    $('#toggle_filter').click(function(){
        if($('#filter').is(':hidden'))
            $('#toggle_filter').html('Hide Filters');
        else {
            $('#toggle_filter').html('Category Filter');
        }
        $('#filter').slideToggle();
        return false;
    });

    // Add Resource
    $('#add_resource').click(function(){
        content_toggle('#new_resource');
        $('#s').focus();
    })
  

    // NEW RESOURCE FUNCTIONS
    jQuery.ajaxSetup({
        'beforeSend': function(xhr) {
            xhr.setRequestHeader("Accept", "text/javascript")
        }
    })

    function reset(){
        $("#s").attr('value','').focus();
        $('#contact_groups').load('/resource/remote/show_all_contacts');
        $.ajax({
            url:'/resource/remote/reload_category_filter',
            success: function(response){
                $('#group_1').html(response);
                $('#all_count').load('/resource/remote/list_count');
            }
        })
    }


    $("#sForm").submit(function(){
        $("#spinner").show('fast');
        $('#yList').hide();
        $.ajax({
            url: 'remote/yp_search',
            data: 'value='+escape($("#s").val()),
            success: function(response,statusText) {
                if(statusText=='success'){
                    $("#spinner").hide('fast');
                    $('#sOut').html(response);
                    $('#yList').show();
                }
            }
        });
        return false;
    });

    $('.add_resource_details').livequery('click',function(){
        $('#listing').attr('value',$(this).attr('rel'))
        $('.resource_title').html($(this).attr('title'))
        $("#show_details").trigger('click');
        return false;
    });

    $('.add_resource').livequery('click',function(){
        $.ajax({
            url: "remote/add_resource?id="+this.rel,
            success: detailsSuccess,
            dataType: 'json'
        })
        return false;
    });

    $('#facebox #hl_skip').livequery("click", function(){
        log('clicked skip');
        $(document).trigger('close.facebox');
        $.flash.notice($(this).attr('rel') + " added!");
        reset();
        return false;
    });

    var options = {
        success:  detailsSuccess,
        dataType: 'json'
    };

    $("#facebox #form_details").livequery(function() {
        $(this).submit(function(){

            log('submitted')
            var container = $('div.errorExplanation');
            $(this).validate({
                errorContainer: container,
                errorLabelContainer: $("ol", container),
                wrapper: 'li',
                rules:  {
                    'resource[who_pays]': {
                        required: true
                    }
                },
                messages: {
                    'resource[who_pays]': {
                        required: 'Please let us know who pays for this resource'
                    }
                }
            }).form();

            if ($(this).valid()) {
                $(this).ajaxSubmit(options);
            }

            return false;
        })
    });

    $('#facebox #form_experience').livequery("submit",function(){
        $(this).ajaxSubmit({
            success: function (response) {
                log('experience added');
                $(document).trigger('close.facebox');
                $.flash.notice(response);
                reset();
            }
        })
        return false;
    });

    function detailsSuccess(json, statusText)  {
        if(statusText=='success'){
            log(json.listing.id);
            log(json.resource.id);

            // show experience
            $('#experience_resource_id').attr('value',json.resource.id);
            $('.resource_title').html(json.listing.title);
            $('#hl_skip').attr('rel',json.listing.title);

            $('#show_experience').trigger('click');
            $('#facebox #experience_comment').focus();
        }
    }


    // CATEGORY FILTER FUNCTIONS

    // Select all
    $("A[href='#select_all']").click( function() {
        $("#" + $(this).attr('rel') + " INPUT[type='checkbox']").attr('checked', true);
        filter_list();
        return false;
    });

    // Select none
    $("A[href='#select_none']").click( function() {
        $("#" + $(this).attr('rel') + " INPUT[type='checkbox']").attr('checked', false);
        filter_list();
        return false;
    });


    // Grouping Options
    function toggle_groupby(){
        var gb;
        if($('#group_by').html()=='Group By Category') {
            gb = 'cat'
            $('#alpha_selector').hide();
            $('#group_by').html('Group A..Z');
        }else{
            gb = 'alpha'
            $('#alpha_selector').show();
            $('#group_by').html('Group By Category');
        }
        return gb
    }

    $('#group_by').click(function(){        
        var gb = toggle_groupby();
        $.ajax({
            url: '/resource/remote/group_contacts?group_by='+gb,
            success: function(response){
                filter_list();
                //$('#contact_groups').html(response);
            }
        })
        return false;
    })

    $('.alpha_letter').click(function(){
        filter_list($(this).attr('rel'));
        return false;
    })

    // All option
    $('#all').click(function(){
        $('#query').val('')
        reset();
    })

    function filter_list(letter){
        var url='/resource/remote/filter_cats';
        if(letter!=undefined) url+='?letter='+letter

        json=get_cb_json();
        $('#cat_spin').show();
        $.ajax({
            url: url,
            data: 'value='+json,
            success: function(response){                
                $('#contact_groups').html(response);
                $('#cat_spin').hide();
                $('#all_count').load('/resource/remote/list_count');
            }
        })
    }

    function get_cb_json() {
        var checked = new Array();
        $("input[rel*=cat_cb]").each(function(){
            if(this.checked) checked.push(parseInt(this.value));
        });

        var json=$.toJSON(checked);      
        return json;
    }

    // filter by category
    $('.cat_reload').click(function(){
        log('cat click');
        filter_list();
    })    

    // delete a resource
    $('#delete_experience').livequery('click',function(){
        log('delete');
        var answer = confirm('Are you sure you want to remove this resource from your list?');
        if(answer) {
            $.ajax({
                url: '/resource/remote/delete',
                data: 'id='+$(this).attr('rel'),
                success: function(response) {
                    $.flash.notice(response);
                    reset();
                    content_toggle('#gMap');
                }
            })
        }
        return false;
    })

    // Search Form Functions
    $('#searchform').submit(function(){
        json=get_cb_json();
        q = $('#query').val();
        if(q!=''){
            $('#cat_spin').show();
            $.ajax({
                url: '/resource/remote/search_contacts',
                data: 'value='+json+'&q='+escape(q),
                success: function(response){
                    $('#contact_groups').html(response);
                    $('#cat_spin').hide();
                    $('#all_count').load('/resource/remote/list_count');
                }
            })
        }
        return false;
    })


    // handle clear of search box
    $('#srch_clear').livequery('click',function(){
        reset();
    })

    var qEntered=false;
    $('#query').click(function(){
        if($(this).val()=='' && qEntered && (navigator.userAgent.toLowerCase().indexOf('safari') >= 0)) {
            log('clearing');
            reset();
            qEntered=false;
        }
    }).keydown(function(){
        qEntered=true;
    })
    


    $('#searchPopup').css('opacity','0'); // set the search popup messgae to 0 opacity

    $('#searchIcon').mouseover(function() {
        $('#searchPopup').stop();	//stops any previous animation
        $('#searchPopup').animate({
            opacity:'1'
        },500);
    });

    $('#searchIcon').mouseout(function() {
        $('#searchPopup').stop();	//stops any previous animation
        $('#searchPopup').animate({
            opacity:'0'
        },500);
    });

    $('#searchIcon').click(function() {
        $('#search').submit();
    });

    $('#searchText').focus(function(){
        if($(this).attr('value') == ''|| $(this).attr('value') == 'Search'){	//test to see if the search field value is empty or 'search' on focus, then remove our holding text
            $(this).attr('value', '');
        }
        $(this).css('color', '#000');

    });
    $('#searchText').blur(function(){	//test to see if the value of our search field is empty, then fill with our holding text
        if($(this).attr('value') == ''){
            $(this).attr('value', 'Search');
            $(this).css('color', '#777');
        }
    });




});
