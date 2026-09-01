// Lays out the post grids on the home page and the category archives.
import Masonry from "masonry-layout"
import imagesLoaded from "imagesloaded"

document.querySelectorAll(".masonrygrid").forEach((grid) => {
  const layout = new Masonry(grid, { itemSelector: ".grid-item" })

  // Post thumbnails have no intrinsic size until they load, so re-run the
  // layout as each one arrives.
  imagesLoaded(grid).on("progress", () => layout.layout())
})
