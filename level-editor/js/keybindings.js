
var cur_keys = [];
var mult = 0;
const valid_keys = [
	"h","j","k","l",
	"ArrowLeft","ArrowDown","ArrowUp","ArrowRight",
	"g","G",
	"H","L","M","m",
	"0","$",
	" ","Enter",
	"d","Backspace",
	"p",
	"x","X","y","Y",
	"c","C",
	"s","S",
	"o","O","a","A",
	"n","N",
	"r"
];
const keys_max_length = 2;
const box_size_step = 8;

function update_key_display() {
	var m = "";
	if (mult > 0) {
		m = String(mult);
	}
	$('#key_display').text(m + cur_keys.join(""));
}

function clear_keys() {
	cur_keys = [];
	mult = 0;
	update_key_display();
}

function add_key(key) {
	if (cur_keys.length >= keys_max_length)
		clear_keys();
	cur_keys.push(key);
	update_key_display();
}

function switch_block_size() {
	var w = settings.block_size.w;
	var h = settings.block_size.h;
	settings.block_size.w = h;
	settings.block_size.h = w;
	update_panel();
}

function switch_block_offset() {
	const x = settings.block_offset.x;
	const y = settings.block_offset.y;
	settings.block_offset.x = y;
	settings.block_offset.y = x;
	update_panel();
}

function increase_box_size(axis) {
	settings.box_size[axis] += box_size_step;
	update_panel();
	update_grid();
}
function decrease_box_size(axis) {
	settings.box_size[axis] -= box_size_step;
	update_panel();
	update_grid();
}

function increase_block_size(axis) {
	const step = Math.round(settings.box_size[axis] / 4);
	settings.block_size[axis] += step;
	update_panel();
}
function decrease_block_size(axis) {
	const step = Math.round(settings.box_size[axis] / 4);
	settings.block_size[axis] -= step;
	update_panel();
}

function increase_block_offset(axis) {
	const side = axis == "x" ? "w" : "h";
	const step = Math.round(settings.box_size[side] / 4);
	settings.block_offset[axis] += step;
	update_panel();
}
function decrease_block_offset(axis) {
	const side = axis == "x" ? "w" : "h";
	const step = Math.round(settings.box_size[side] / 4);
	settings.block_offset[axis] -= step;
	update_panel();
}

function next_block() {
	const select = $('#panel__block_selector__select');
	const cur = select.val();
	var next_i = 0;
	const children = select.children('option');
	children.each(function (i) {
		if ($(this).val() == cur) {
			next_i = i + 1;
			return;
		}
	});
	if (next_i >= children.length) {
		next_i = next_i - children.length;
	}
	select.val($(children.get(next_i)).val());
	select.trigger("change");
}
function prev_block() {
	const select = $('#panel__block_selector__select');
	const cur = select.val();
	var prev_i = 0;
	const children = select.children('option');
	children.each(function (i) {
		if ($(this).val() == cur) {
			prev_i = i - 1;
			return;
		}
	});
	if (prev_i < 0) {
		prev_i = children.length + prev_i;
	}
	select.val($(children.get(prev_i)).val());
	select.trigger("change");
}

function reset(target) {
	switch (target) {
		case "box":
			settings.box_size = deep_copy(default_settings.box_size);
			update_grid();
			break;
		case "block":
			settings.block_size = deep_copy(default_settings.block_size);
			break;
		case "offset":
			settings.block_offset = deep_copy(default_settings.block_offset);
			break;
		case "all":
			reset("box");
			reset("block");
			reset("offset");
			break;
	}
	update_panel();
}

function move_highlight(dir) {
	const highlight = $('#grid__block__highlight');
	const x = parseInt(highlight.data("x")) - (parseInt(highlight.data("x")) % settings.box_size.w);
	const y = parseInt(highlight.data("y")) - (parseInt(highlight.data("y")) % settings.box_size.h);
	const step = {
		x: settings.box_size.w,
		y: settings.box_size.h
	}
	switch (dir) {
		case "left":
			if ((x - step.x) >= 0)
				highlight.data("x", x - step.x);
			break;
		case "right":
			if ((x + step.x) < settings.room_size.w)
				highlight.data("x", x + step.x);
			break;
		case "up":
			if ((y - step.y) >= 0)
				highlight.data("y", y - step.y);
			break;
		case "down":
			if ((y + step.y) < settings.room_size.h)
				highlight.data("y", y + step.y);
			break;
		default:
			return;
	}
	update_highlight();
}

function remove_block_keypress() {
	const highlight = $('#grid__block__highlight');
	const x = highlight.data("x") + settings.block_offset.x;
	const y = highlight.data("y") + settings.block_offset.y;
	remove_block(x, y);
}

function move_highlight_to(target) {
	const highlight = $('#grid__block__highlight');
	var x, y, bottom, end;
	switch (target) {
		case "top":
			highlight.data("y", "0");
			break;
		case "bottom":
			bottom = (settings.room_size.h - 1) - ((settings.room_size.h - 1) % settings.box_size.h);
			highlight.data("y", bottom);
			break;
		case "start":
			highlight.data("x", "0");
			break;
		case "end":
			end = (settings.room_size.w - 1) - ((settings.room_size.w - 1) % settings.box_size.w);
			highlight.data("x", end);
			break;
		case "center":
			x = ((settings.room_size.w / 2) - 1) - (((settings.room_size.w / 2) - 1) % settings.box_size.w);
			y = ((settings.room_size.h / 2) - 1) - (((settings.room_size.h / 2) - 1) % settings.box_size.w);
			highlight.data("x", x);
			highlight.data("y", y);
			break;
		case "center_row":
			y = ((settings.room_size.h / 2) - 1) - (((settings.room_size.h / 2) - 1) % settings.box_size.w);
			highlight.data("y", y);
			break;
		default:
			return;
	}
	update_highlight();
}


function handle_keypress(event) {
	console.log(event.key);
	// Return if target is inside panel
	if ($(event.target).parents('#panel').length == 1)
		return;

	// Clear keys if Escape was pressed
	if (event.key == "Escape") {
		clear_keys();
		return;
	}

	// Multiplier key - Number
	if (event.key.match(/[0-9]/) != null) {
		if (!(event.key == "0" && mult == 0)) {
			if (mult == 0)
				mult = "";
			mult = parseInt(String(mult) + event.key);
			update_key_display();
			return;
		}
	}

	// Return if not valid key
	if (!valid_keys.includes(event.key))
		return;

	add_key(event.key);

	var found_comb = true;

	var loop = 1;
	if (mult > 0)
		loop = mult;

	// Check key combination
	for (var i = 0; i < loop; i++) {
		switch (cur_keys.join("")) {
			// hjkl, block movement
			case "h":  // left
			case "ArrowLeft":
				move_highlight("left");
				break;
			case "l":  // right
			case "ArrowRight":
				move_highlight("right");
				break;
			case "k":  // up
			case "ArrowUp":
				move_highlight("up");
				break;
			case "j":  // down
			case "ArrowDown":
				move_highlight("down");
				break;

			// Move highlight to top row
			case "g":
			case "H":
				move_highlight_to("top");
				break;
			// Move highlight to bottom row
			case "G":
			case "L":
				move_highlight_to("bottom");
				break;
			// Move highlight to center row
			case "M":
				move_highlight_to("center_row");
				break;
			// Move highlight to center
			case "m":
				move_highlight_to("center");
				break;
			// Move highlight to beginning of row
			case "0":
				move_highlight_to("start");
				break;
			// Move highlight to end of row
			case "$":
				move_highlight_to("end");
				break;

			// Place block (highlight)
			case " ":
			case "Enter":
				place_highlight();
				break;

			// Remove block
			case "d":
			case "Backspace":
				remove_block_keypress();
				break;

			// Toggle panel
			case "p":
				toggle_panel();
				break;

			// Switch block size
			case "x":
				switch_block_size();
				break;
			// Switch block offset
			case "X":
				switch_block_offset();
				break;

			// Increase box size - w
			case "cx":
				increase_box_size("w");
				break;
			// Increase box size - h
			case "cy":
				increase_box_size("h");
				break;
			// Decrease box size - w
			case "cX":
			case "Cx":
			case "CX":
				decrease_box_size("w");
				break;
			// Decrease box size - h
			case "cY":
			case "Cy":
			case "CY":
				decrease_box_size("h");
				break;

			// Increase block size - w
			case "sx":
				increase_block_size("w");
				break;
			// Increase block size - h
			case "sy":
				increase_block_size("h");
				break;
			// Decrease block size - w
			case "sX":
			case "Sx":
			case "SX":
				decrease_block_size("w");
				break;
			// Decrease block size - h
			case "sY":
			case "Sy":
			case "SY":
				decrease_block_size("h");
				break;

			// Increase block offset - x
			case "ox":
			case "ax":
				increase_block_offset("x");
				break;
			// Increase block offset - y
			case "oy":
			case "ay":
				increase_block_offset("y");
				break;
			// Decrease block offset - x
			case "oX":
			case "Ox":
			case "OX":
			case "aX":
			case "Ax":
			case "AX":
				decrease_block_offset("x");
				break;
			// Decrease block offset - y
			case "oY":
			case "Oy":
			case "OY":
			case "aY":
			case "Ay":
			case "AY":
				decrease_block_offset("y");
				break;

			// BLOCK SELECTIOn
			// Next block
			case "n":
				next_block();
				break;
			// Previous block
			case "N":
				prev_block();
				break;

			// RESETS
			// Reset box size
			case "rc":
			case "cr":
				reset("box");
				break;
			// Reset block size
			case "rs":
			case "sr":
				reset("block");
				break;
			// Reset offset size
			case "ro":
			case "or":
			case "ra":
			case "ar":
				reset("offset");
				break;
			// Reset ALL
			case "rr":
				reset("all");
				break;

			default:
				found_comb = false;
		}
	}

	if (found_comb) {
		clear_keys();
	}

}


$(document).ready(function () {
	document.addEventListener("keydown", handle_keypress);
});

