
function init_panel(panel) {
	[
		panel.find('#panel__box_size__w'),
		panel.find('#panel__box_size__h'),
		panel.find('#panel__block_size__w'),
		panel.find('#panel__block_size__h'),
		panel.find('#panel__block_offset__x'),
		panel.find('#panel__block_offset__y')
	].forEach(function (el) {
		el.get(0).addEventListener("change", function (event) {
			const input = $(event.target);
			const val = el.val();
			switch (input.attr("id")) {
				case 'panel__box_size__w':
					settings.box_size.w = parseInt(val);
					break;
				case 'panel__box_size__h':
					settings.box_size.h = parseInt(val);
					break;
				case 'panel__block_size__w':
					settings.block_size.w = parseInt(val);
					break;
				case 'panel__block_size__h':
					settings.block_size.h = parseInt(val);
					break;
				case 'panel__block_offset__x':
					settings.block_offset.x = parseInt(val);
					break;
				case 'panel__block_offset__y':
					settings.block_offset.y = parseInt(val);
					break;
				default:
			}

			update_panel(panel);
			update_grid($('#grid'));
		});
	});

	update_panel(panel);
}

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

	box_size_el.w.val(settings.box_size.w);
	box_size_el.h.val(settings.box_size.h);
	block_size_el.w.val(settings.block_size.w);
	block_size_el.h.val(settings.block_size.h);
	block_offset_el.x.val(settings.block_offset.x);
	block_offset_el.y.val(settings.block_offset.y);
}

function populate_block_selector() {
	const block_selector = $('#panel__block_selector select');
	$.getJSON('./instances.json', function (json) {
		const option = '<option value="REPLACEVALUE">REPLACENAME</option>';
		json.forEach(function (name) {
			block_selector.append(
				option.replace("REPLACEVALUE", name)
				      .replace("REPLACENAME", name)
			);
		});
	});
}

$(document).ready(function () {

	const panel = $('#panel')
	init_panel(panel);

	populate_block_selector();

});

