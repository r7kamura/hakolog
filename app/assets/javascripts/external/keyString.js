function keyString (e) {
  var key, ret = '';
  if      (e.ctrlKey)  ret += 'C-';
  if      (e.altKey)   ret += 'M-';
  if      (e.shiftKey) ret += 'S-';
  else if (e.metaKey)  ret += 'W-';

  if (e.which == 0) {
    ret += arguments.callee.codeMap[e.keyCode];
  } else {
    if (key = arguments.callee.codeMap[e.which]) {
      ret += key;
    } else {
      if (e.shiftKey) {
        ret = ret.replace(/^S-/, '');
        ret += String.fromCharCode(e.which).toUpperCase();
      } else {
        ret += String.fromCharCode(e.which).toLowerCase();
      }
    }
  }

  return ret;
}

keyString.codeMap = {
    8: 'BackSpace',
    9: 'Tab',
   13: 'Return',
   27: 'Esc',
   32: 'Space',
   33: 'PageUp',
   34: 'PageDown',
   35: 'End',
   36: 'Home',
   37: 'Left',
   38: 'Up',
   39: 'Right',
   40: 'Down',
   45: 'Insert',
   46: 'Delete',
  112: 'F1',
  113: 'F2',
  114: 'F3',
  115: 'F4',
  116: 'F5',
  117: 'F6',
  118: 'F7',
  119: 'F8',
  120: 'F9',
  121: 'F10',
  122: 'F11',
  123: 'F12'
};
