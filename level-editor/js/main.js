
const default_settings = {
	screen: {
		w: parseInt($('#grid_wrapper').css("width")),
		h: parseInt($('#grid_wrapper').css("height"))
	},
	box_size: {
		w: 32, h: 32
	},
	block_size: {
		w: 32, h: 32
	},
	block_offset: {
		x: 0, y: 0
	},
	room_size: {
		w: 960, h: 640
	},

	colors: {}
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
			x:    parseInt($(this).css("left")),
			y:    parseInt($(this).css("top")),
			w:    parseInt($(this).css("width")),
			h:    parseInt($(this).css("height")),
			type: $(this).data("instance")
		});
	});

	const data = {
		instances: blocks,
		size: {
			w: settings.room_size.w,
			h: settings.room_size.h
		}
	}
	const data_string = JSON.stringify(data);
	// Copy level data to clipboard
	copy_to_clipboard(data_string);
	// Create textarea with level data
	const data_el = $(document.createElement('textarea'));
		data_el.attr("id", "level_data");
		data_el.attr("rows", "20");
		data_el.text(data_string);
	$('#panel').append(data_el);

	// Get level name
	var name = $('#level_name').val();
	if (name.search(/\.json$/) == -1) {
		name += ".json";
	}

	// Prompt user for download
	download_json(data, name);
}

// https://stackoverflow.com/a/30800715
function download_json(exportObj, exportName){
	var dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(exportObj));
	var dlAnchorElem = document.getElementById('download_level');
	dlAnchorElem.setAttribute("href",     dataStr     );
	dlAnchorElem.setAttribute("download", exportName);
	dlAnchorElem.click();
}

$(document).ready(function () {
	const save_btn = $('#save_btn');

	save_btn.get(0).addEventListener("click", save_level);
});

