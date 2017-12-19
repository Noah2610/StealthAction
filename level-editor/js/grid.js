
function update_highlight(highlight) {
	highlight.css("width", settings.block_size.w);
	highlight.css("height", settings.block_size.h);
	highlight.css("left", highlight.data("x") + settings.block_offset.x);
	highlight.css("top", highlight.data("y") + settings.block_offset.y);
}

function update_grid(grid) {
	grid.empty();

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

function handle_mousemove(event, highlight) {
	const x = event.pageX;
	const y = event.pageY;
	const box_x = x - (x % settings.box_size.w);
	const box_y = y - (y % settings.box_size.h);

	//const box_el = $('#grid .grid__box[data-x="'+ box_x +'"][data-y="'+ box_y +'"]');
	
	highlight.data("x", box_x);
	highlight.data("y", box_y);
	update_highlight(highlight);
}

$(document).ready(function () {

	const grid = $('#grid');
	const highlight = $('#grid__block__highlight');
	update_highlight(highlight);

	update_grid(grid);
	grid.get(0).addEventListener("mousemove", function (event) {
		handle_mousemove(event, highlight);
	});

});
