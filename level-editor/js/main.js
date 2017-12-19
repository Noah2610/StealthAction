
const default_settings = {
	screen: {
		w: 960,
		h: 640
	},
	box_size: {
		w: 32, h: 32
	},
	block_size: {
		w: 32, h: 32
	},
	block_offset: {
		x: 0, y: 0
	}
};

var settings = default_settings;

function copy_to_clipboard(text) {
	var textArea = document.createElement("textarea");
	// Place in top-left corner of screen regardless of scroll position.
	textArea.style.position = 'fixed';
	textArea.style.top = 0;
	textArea.style.left = 0;
	// Ensure it has a small width and height. Setting to 1px / 1em
	// doesn't work as this gives a negative w/h on some browsers.
	textArea.style.width = '2em';
	textArea.style.height = '2em';
	// We don't need padding, reducing the size if it does flash render.
	textArea.style.padding = 0;
	// Clean up any borders.
	textArea.style.border = 'none';
	textArea.style.outline = 'none';
	textArea.style.boxShadow = 'none';
	// Avoid flash of white box if rendered for any reason.
	textArea.style.background = 'transparent';

	textArea.value = text;
	document.body.appendChild(textArea);
	textArea.select();
	document.execCommand('copy');
	document.body.removeChild(textArea);
}

function current_block() {
	const select = $('#panel__block_selector');
	return select.find('option:selected').val();
}

function save_level() {
	$('#level_data').remove();

	const blocks_el = $('#blocks').children('.block');
	var blocks = [];

	blocks_el.each(function (index) {
		blocks.push({
			x:    $(this).css("left"),
			y:    $(this).css("top"),
			w:    $(this).css("width"),
			h:    $(this).css("height"),
			type: $(this).data("instance")
		});
	});

	const data = JSON.stringify(blocks);
	// Copy level data to clipboard
	copy_to_clipboard(data);
	// Create textarea with level data
	const data_el = $(document.createElement('textarea'));
		data_el.attr("id", "level_data");
		data_el.attr("rows", "20");
		data_el.text(data);
	$('#panel').append(data_el);

}

$(document).ready(function () {
	const save_btn = $('#save_btn');

	save_btn.get(0).addEventListener("click", save_level);
});

