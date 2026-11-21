import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "combobox", "list", "toggle"]

  connect() {
    this.options = Array.from(this.selectTarget.options)
      .filter((option) => option.value !== "")
      .map((option) => ({ value: option.value, label: option.text }))

    this.highlightedIndex = -1
    this.closeDelay = null
    this.syncFromSelect()
  }

  disconnect() {
    window.clearTimeout(this.closeDelay)
    this.resetListPosition()
  }

  filter() {
    const query = this.comboboxTarget.value.trim()
    const visible = this.filteredOptions(query)
    this.highlightedIndex = visible.length > 0 ? 0 : -1
    this.presentList(visible)
  }

  filteredOptions(query) {
    if (!query) return this.options

    const normalized = query.toLowerCase()
    return this.options.filter((option) => option.label.toLowerCase().includes(normalized))
  }

  focus() {
    window.clearTimeout(this.closeDelay)
    this.comboboxTarget.value = ""
    this.openList("")
  }

  click() {
    window.clearTimeout(this.closeDelay)
    this.comboboxTarget.value = ""
    this.openList("")
  }

  toggleDropdown(event) {
    event.preventDefault()
    window.clearTimeout(this.closeDelay)

    if (this.listTarget.classList.contains("hidden")) {
      this.comboboxTarget.focus()
      this.openList("")
      return
    }

    this.closeNow()
  }

  openList(query, { resetHighlight = true } = {}) {
    const visible = this.filteredOptions(query)
    if (resetHighlight) {
      this.highlightedIndex = visible.length > 0 ? 0 : -1
    }
    this.presentList(visible)
  }

  presentList(visible) {
    this.renderList(visible)
    this.listTarget.classList.remove("hidden")
    this.comboboxTarget.setAttribute("aria-expanded", "true")
    this.positionList()
    if (this.hasToggleTarget) {
      this.toggleTarget.setAttribute("aria-expanded", "true")
    }
  }

  ensureListVisible() {
    const query = this.comboboxTarget.value.trim()
    const visible = this.filteredOptions(query)

    if (this.listTarget.classList.contains("hidden")) {
      if (this.highlightedIndex < 0 && visible.length > 0) {
        this.highlightedIndex = 0
      }
      this.presentList(visible)
      return visible
    }

    this.positionList()
    return visible
  }

  close() {
    this.closeDelay = window.setTimeout(() => this.closeNow(), 180)
  }

  closeNow() {
    window.clearTimeout(this.closeDelay)
    this.listTarget.classList.add("hidden")
    this.comboboxTarget.setAttribute("aria-expanded", "false")
    if (this.hasToggleTarget) {
      this.toggleTarget.setAttribute("aria-expanded", "false")
    }
    this.highlightedIndex = -1
    this.resetListPosition()
    this.syncFromSelect()
  }

  cancelClose() {
    window.clearTimeout(this.closeDelay)
  }

  syncFromSelect() {
    const selected = this.options.find((option) => option.value === this.selectTarget.value)
    this.comboboxTarget.value = selected ? selected.label : ""
  }

  choose(event) {
    event.preventDefault()
    const item = event.target.closest("[data-value]")
    if (!item) return

    window.clearTimeout(this.closeDelay)
    this.selectTarget.value = item.dataset.value
    this.selectTarget.dispatchEvent(new Event("change", { bubbles: true }))
    this.syncFromSelect()
    this.closeNow()
  }

  keydown(event) {
    if (event.key === "Escape") {
      if (!this.listTarget.classList.contains("hidden")) {
        event.stopPropagation()
        this.closeNow()
      }
      return
    }

    if (event.key === "ArrowDown") {
      event.preventDefault()
      const visible = this.ensureListVisible()
      this.moveHighlight(1, visible)
      return
    }

    if (event.key === "ArrowUp") {
      event.preventDefault()
      const visible = this.ensureListVisible()
      this.moveHighlight(-1, visible)
      return
    }

    if (event.key === "Enter") {
      if (this.listTarget.classList.contains("hidden")) return

      event.preventDefault()
      const visible = this.filteredOptions(this.comboboxTarget.value.trim())
      const option = visible[this.highlightedIndex] || visible[0]
      if (!option) return

      this.selectTarget.value = option.value
      this.selectTarget.dispatchEvent(new Event("change", { bubbles: true }))
      this.syncFromSelect()
      this.closeNow()
    }
  }

  moveHighlight(direction, visible) {
    const options = visible || this.filteredOptions(this.comboboxTarget.value.trim())
    if (options.length === 0) return

    if (this.highlightedIndex < 0) {
      this.highlightedIndex = direction > 0 ? 0 : options.length - 1
    } else {
      const next = this.highlightedIndex + direction
      this.highlightedIndex = Math.max(0, Math.min(next, options.length - 1))
    }

    this.renderList(options)
    this.scrollHighlightedIntoView()
  }

  scrollHighlightedIntoView() {
    if (this.highlightedIndex < 0) return

    const item = this.listTarget.children[this.highlightedIndex]
    item?.scrollIntoView({ block: "nearest" })
  }

  renderList(options) {
    this.listTarget.replaceChildren()

    if (options.length === 0) {
      const empty = document.createElement("li")
      empty.className = "px-3 py-2 text-sm text-slate-500"
      empty.textContent = "Nenhuma opção encontrada"
      this.listTarget.appendChild(empty)
      return
    }

    options.forEach((option, index) => {
      const item = document.createElement("li")
      const selected = option.value === this.selectTarget.value
      const highlighted = index === this.highlightedIndex

      item.dataset.value = option.value
      item.setAttribute("role", "option")
      item.setAttribute("aria-selected", highlighted ? "true" : "false")
      item.className = [
        "cursor-pointer px-3 py-2 text-sm text-slate-800",
        highlighted ? "bg-sky-50 text-sky-900" : "hover:bg-slate-50",
        selected && !highlighted ? "font-medium text-sky-800" : "",
      ].join(" ")
      item.textContent = option.label
      item.addEventListener("mousedown", (event) => this.choose(event))
      item.addEventListener("click", (event) => this.choose(event))

      this.listTarget.appendChild(item)
    })
  }

  positionList() {
    const rect = this.comboboxTarget.getBoundingClientRect()
    this.listTarget.style.position = "fixed"
    this.listTarget.style.left = `${rect.left}px`
    this.listTarget.style.top = `${rect.bottom + 4}px`
    this.listTarget.style.width = `${rect.width}px`
    this.listTarget.style.zIndex = "250"
  }

  resetListPosition() {
    this.listTarget.style.position = ""
    this.listTarget.style.left = ""
    this.listTarget.style.top = ""
    this.listTarget.style.width = ""
    this.listTarget.style.zIndex = ""
  }
}