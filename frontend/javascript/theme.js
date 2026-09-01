// Behaviour that came with the Mediumish theme, rewritten without jQuery.
// The theme's share bar, alert bar, back-to-top button and smooth-scroll
// anchors are gone: none of those elements exist in this site's templates.

const header = document.querySelector("header")
const siteContent = document.querySelector(".site-content")

// The header is `position: fixed`, so the content below it needs a matching
// offset. ResizeObserver keeps it right when the navbar wraps to another row.
if (header && siteContent) {
  const syncContentOffset = () => {
    siteContent.style.marginTop = `${header.offsetHeight}px`
  }

  syncContentOffset()
  new ResizeObserver(syncContentOffset).observe(header)
}

// Tuck the header away while scrolling down, bring it back on the way up.
if (header) {
  // Ignore scroll jitter below this many pixels.
  const DELTA = 5

  let lastScrollTop = window.scrollY
  let ticking = false

  const update = () => {
    ticking = false

    const scrollTop = window.scrollY
    if (Math.abs(lastScrollTop - scrollTop) <= DELTA) return

    if (scrollTop > lastScrollTop && scrollTop > header.offsetHeight) {
      // Scrolled down past the header: move it fully out of view so nothing
      // shows through it.
      header.classList.remove("nav-down")
      header.classList.add("nav-up")
      header.style.top = `${-header.offsetHeight}px`
    } else if (scrollTop + window.innerHeight < document.documentElement.scrollHeight) {
      // Scrolled up, and not just bouncing at the bottom of the page.
      header.classList.remove("nav-up")
      header.classList.add("nav-down")
      header.style.top = "0px"
    }

    lastScrollTop = scrollTop
  }

  document.addEventListener(
    "scroll",
    () => {
      if (ticking) return
      ticking = true
      requestAnimationFrame(update)
    },
    { passive: true }
  )
}

// Paginated pages drop a marker where the post list starts, so readers landing
// on page 2 and beyond skip the intro they have already seen.
const jumpTarget = document.querySelector("#jumptopageof")

if (jumpTarget) {
  window.scrollTo({
    top: jumpTarget.getBoundingClientRect().top + window.scrollY,
    behavior: "smooth",
  })
}
