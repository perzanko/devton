// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
const page = window.location.pathname.substring(1) || 'home'
document.body.querySelectorAll('nav > a').forEach((menuItem) => {
  if (menuItem.getAttribute('href').includes(page)) {
    menuItem.style.textDecoration = 'underline'
  }
})

document.querySelector('.hamburger').addEventListener('click', () => {
  const { classList } = document.body.querySelector('nav')
  if (classList.contains('active')) {
    classList.remove('active')
  } else {
    classList.add('active')
  }
})
