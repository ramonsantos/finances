import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 5000 }
  }

  connect() {
    this.remainingMs = this.timeoutValue
    this.dismissing = false
    this.startTimer()
  }

  disconnect() {
    this.clearTimer()
  }

  pause() {
    if (this.dismissing || !this.deadline) return

    this.remainingMs = Math.max(this.deadline - Date.now(), 0)
    this.clearTimer()
  }

  resume() {
    if (this.dismissing || this.timer) return

    this.startTimer()
  }

  dismiss() {
    if (this.dismissing) return

    this.dismissing = true
    this.clearTimer()
    this.element.remove()
  }

  startTimer() {
    this.clearTimer()
    if (this.remainingMs <= 0) {
      this.dismiss()
      return
    }

    this.deadline = Date.now() + this.remainingMs
    this.timer = window.setTimeout(() => {
      this.dismiss()
    }, this.remainingMs)
  }

  clearTimer() {
    if (this.timer) {
      window.clearTimeout(this.timer)
      this.timer = null
    }

    this.deadline = null
  }
}