import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { interval: { type: Number, default: 3000 } }

  connect() {
    this.timer = setInterval(() => {
      if (document.visibilityState === "visible") {
        Turbo.visit(window.location.href, { action: "replace" })
      }
    }, this.intervalValue)
  }

  disconnect() {
    clearInterval(this.timer)
  }
}