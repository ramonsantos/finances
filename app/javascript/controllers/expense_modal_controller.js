import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox"]

  connect() {
    this.onKeydown = this.handleKeydown.bind(this)
    window.addEventListener("keydown", this.onKeydown)
  }

  disconnect() {
    window.removeEventListener("keydown", this.onKeydown)
  }

  close() {
    this.checkboxTarget.checked = false
  }

  handleKeydown(event) {
    if (event.key !== "Escape") return
    if (!this.checkboxTarget.checked) return

    this.close()
  }
}