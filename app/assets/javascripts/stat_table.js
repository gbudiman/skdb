function format_mute_name(value, row, index) {
	return value.mute_hero_banner();
}

function resize_bst_area() {
	$('.fixed-table-container').css('height', '80vh');
	$('#stat-table').bootstrapTable('resetWidth');
}

$(window).on('resize', resize_bst_area);