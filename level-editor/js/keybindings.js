
var cur_keys = [];
var mult = 0;
const valid_keys = [
	"x","X","y","Y","c","C","s","S","o","O","a","A","n","N","r"
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

function handle_keypress(event) {
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
		//set_mult(parseInt(event.key));
		if (mult == 0)
			mult = "";
		mult = parseInt(String(mult) + event.key);
		update_key_display();
		return;
	}

	// Return if not valid key
	if (!valid_keys.includes(event.key))
		return;

	add_key(event.key);

	var found_comb = true;

	var loop = 1;
	if (mult > 0)
		loop = mult;

	for (var i = 0; i < loop; i++) {
		switch (cur_keys.join("")) {
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

