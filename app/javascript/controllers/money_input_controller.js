import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    if (this.hasInputTarget && this.inputTarget.value) {
      this.formatDisplay()
    }
  }

  formatDisplay() {
    const digits = this.inputTarget.value.replace(/\D/g, "")
    if (!digits) return

    const amount = (parseInt(digits, 10) / 100).toFixed(2)
    const [whole, cents] = amount.split(".")
    const wholeFormatted = whole.replace(/\B(?=(\d{3})+(?!\d))/g, ".")
    this.inputTarget.value = `R$ ${wholeFormatted},${cents}`
  }

  input() {
    this.formatDisplay()
  }

  beforeSubmit() {
    this.inputTargets.forEach((input) => {
      const digits = input.value.replace(/\D/g, "")
      if (digits) {
        input.value = (parseInt(digits, 10) / 100).toFixed(2).replace(".", ",")
      }
    })
  }
}