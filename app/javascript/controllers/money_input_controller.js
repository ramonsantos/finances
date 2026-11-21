import { Controller } from "@hotwired/stimulus"

const NAVIGATION_KEYS = new Set([
  "Backspace",
  "Delete",
  "Tab",
  "ArrowLeft",
  "ArrowRight",
  "ArrowUp",
  "ArrowDown",
  "Home",
  "End",
])

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.inputTargets.forEach((input) => {
      input.setAttribute("inputmode", "numeric")
      input.setAttribute("autocomplete", "off")
      if (input.value) this.formatField(input)
    })
  }

  input(event) {
    this.formatField(event.target)
  }

  keydown(event) {
    if (NAVIGATION_KEYS.has(event.key)) return
    if (event.ctrlKey || event.metaKey) return
    if (/^\d$/.test(event.key)) return

    event.preventDefault()
  }

  paste(event) {
    event.preventDefault()
    const digits = event.clipboardData.getData("text").replace(/\D/g, "")
    if (!digits) return

    event.target.value = digits
    this.formatField(event.target)
  }

  beforeSubmit() {
    this.inputTargets.forEach((input) => {
      const digits = input.value.replace(/\D/g, "")
      input.value = digits ? (parseInt(digits, 10) / 100).toFixed(2) : ""
    })
  }

  formatField(input) {
    const digits = input.value.replace(/\D/g, "")
    if (!digits) {
      input.value = ""
      return
    }

    const amount = (parseInt(digits, 10) / 100).toFixed(2)
    const [whole, cents] = amount.split(".")
    const wholeFormatted = whole.replace(/\B(?=(\d{3})+(?!\d))/g, ".")
    input.value = `R$ ${wholeFormatted},${cents}`
  }
}