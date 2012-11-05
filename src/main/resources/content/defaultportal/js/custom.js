$(document).ready(function() {

// Set the date by modifying the date in next line (September 19, 2013 00:00:00):

		var austDay = new Date("September 19, 2012 00:00:00");
			$('#countdown').countdown({until: austDay, layout: '<div class="item"><p>{dn}</p> <span class="days">{dl}</span><div class="lines"></div></div> <div class="item"><p>{hn}</p> <span class="hours">{hl}</span><div class="lines"></div></div> <div class="item"><p>{mn}</p> <span class="minutes">{ml}</span><div class="lines"></div></div> <div class="item"><p>{sn}</p> <span class="seconds">{sl}</span></div>'});
			$('#year').text(austDay.getFullYear());
	
});	