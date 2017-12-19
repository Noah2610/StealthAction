
function update_panel(panel) {
	const box_size_el = {
		w: panel.find('#panel__box_size__w'),
		h: panel.find('#panel__box_size__h')
	};

	const block_size_el = {
		w: panel.find('#panel__block_size__w'),
		h: panel.find('#panel__block_size__h')
	};

	const block_offset_el = {
		x: panel.find('#panel__block_offset__x'),
		y: panel.find('#panel__block_offset__y')
	};

	box_size_el.w.text(settings.box_size.w);
	box_size_el.h.text(settings.box_size.h);
	block_size_el.w.text(settings.block_size.w);
	block_size_el.h.text(settings.block_size.h);
	block_offset_el.x.text(settings.block_offset.x);
	block_offset_el.y.text(settings.block_offset.y);
}

$(document).ready(function () {

	const panel = $('#panel')
	update_panel(panel);

});

