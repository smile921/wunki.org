$(document).ready(function() {
    // Timeago
    $("time.timeago").timeago();
		$().UItoTop({ easingType: 'easeOutExpo' });

    // Scroll to anchors
    $("a").each(function(idx) {
        if ($(this).attr('href').match(/^#/)) {
            $(this).anchorScroll({fx: 'easeOutExpo'});
        }
    });

    $(".colorbox").colorbox({
        fixed: true
    });

    // Add extra information to code blocks
    $('code').each(function(){
        var title = $(this).attr("class");
        
        if(title != ''){
            if(title.match('sourceCode')){
                var title = title.split(' ')[1];
            };
            $(this).before('<span class="language">'+title+'</span>');
        };
    });
});
