// Registers the `$.fn.masonry` and `$.fn.imagesLoaded` plugins that
// `vendor/theme.js` uses to lay out the post grid.
import jQuery from "./globals.js"
import jQueryBridget from "jquery-bridget"
import Masonry from "masonry-layout"
import imagesLoaded from "imagesloaded"

jQueryBridget("masonry", Masonry, jQuery)
imagesLoaded.makeJQueryPlugin(jQuery)
