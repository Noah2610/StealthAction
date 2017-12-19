
function gen_grid(grid) {
	const box_w = settings.box_size.w;
	const box_h = settings.box_size.h;
	const style = 'width: '+ box_w +'px; height: '+ box_h +'px;';
	const box_el = '<span class="grid__box" style="'+ style +'" data-x="0" data-y="0"></span>';
	
	const boxes_x = Math.floor(settings.screen.w / box_w);
	const boxes_y = Math.floor(settings.screen.h / box_h);

	for (var row = 0; row < boxes_y; row++) {
		for (var col = 0; col < boxes_x; col++) {
			grid.append(
				box_el.replace('data-x="0"', 'data-x="'+ col * box_w +'"')
				      .replace('data-y="0"', 'data-y="'+ row * box_h +'"')
			);
		}
		grid.append('<br />');
	}
}

function handle_mouse(event) {
	const x = event.clientX;
	const y = event.clientY;
	const box_x = event.clientX - (event.clientX % settings.box_size.x);
}

$(document).ready(function () {

	const grid = $('#grid');

	gen_grid(grid);
	grid.get(0).addEventListener("mousemove", handle_mouse);

});
