import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbomodal"
export default class extends Controller {
  submitEnd(e) { 
    console.log("SUBMT")
    if (e.detail.success) { 
      this.hideModal()
    }
  }
  hideModal() {
    this.element.remove(  )
  }
}
