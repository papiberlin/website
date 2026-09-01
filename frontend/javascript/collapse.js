// Stand-in for Bootstrap's collapse plugin, the only piece of Bootstrap's
// JavaScript this site used (the navbar toggler in `_layouts/default.html`).
// Bootstrap 4 alpha's own bundle needs jQuery and Tether, so we keep its CSS
// and drive the `collapse` / `collapsing` / `show` classes ourselves.

// Matches the `.collapsing` height transition in bootstrap.css.
const DURATION = 350

// Reading a layout property flushes pending style changes, so the browser
// animates from the height we just set instead of collapsing both steps
// into one frame.
const reflow = (element) => element.getBoundingClientRect()

const afterTransition = (element, done) => {
  let timer

  const finish = () => {
    clearTimeout(timer)
    element.removeEventListener("transitionend", onEnd)
    done()
  }

  const onEnd = (event) => {
    if (event.target === element && event.propertyName === "height") finish()
  }

  // Fall back to a timer in case the transition never fires (reduced motion,
  // a hidden tab, an interrupted animation).
  timer = setTimeout(finish, DURATION + 50)
  element.addEventListener("transitionend", onEnd)
}

const expand = (target) => {
  target.classList.remove("collapse")
  target.classList.add("collapsing")
  target.style.height = "0px"
  reflow(target)
  target.style.height = `${target.scrollHeight}px`

  afterTransition(target, () => {
    target.classList.remove("collapsing")
    target.classList.add("collapse", "show")
    target.style.height = ""
  })
}

const collapse = (target) => {
  target.style.height = `${target.getBoundingClientRect().height}px`
  reflow(target)
  target.classList.remove("collapse", "show")
  target.classList.add("collapsing")
  target.style.height = "0px"

  afterTransition(target, () => {
    target.classList.remove("collapsing")
    target.classList.add("collapse")
    target.style.height = ""
  })
}

document.addEventListener("click", (event) => {
  const trigger = event.target.closest('[data-toggle="collapse"]')
  if (!trigger) return

  const selector = trigger.dataset.target || trigger.getAttribute("href")
  const target = selector && document.querySelector(selector)
  if (!target) return

  event.preventDefault()

  // Ignore clicks while a previous toggle is still animating.
  if (target.classList.contains("collapsing")) return

  const expanded = target.classList.contains("show")
  expanded ? collapse(target) : expand(target)
  trigger.setAttribute("aria-expanded", String(!expanded))
})
