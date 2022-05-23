import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-form"
export default class extends Controller {
  search() {
    console.log(this.element)
      clearTimeout(this.timeout)
      this.timeout = setTimeout(()=>{
        this.element.requestSubmit();
      }, 200)
  }
}
