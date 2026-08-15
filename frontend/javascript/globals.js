// The theme's JavaScript is pre-module: Bootstrap 4 alpha throws unless it finds
// a global jQuery, and `vendor/theme.js` calls `$` / `jQuery` directly.
//
// This module is imported first from `index.js`. ES module bodies run in import
// order, so the globals are in place before anything that needs them loads.
import jQuery from "jquery"
import Tether from "tether"

window.jQuery = window.$ = jQuery
window.Tether = Tether

export default jQuery
