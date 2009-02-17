// RESOURCE.JS

$(document).ready(function(){

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
