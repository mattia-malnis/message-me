import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chat-display"
export default class extends Controller {
  static values = { token: String };
  static targets = ["messagesContainer"];

  connect() {
    // remove "new message" badge from the chat on the sidebar
    this.hideBadge();

    // scroll to the bottom of the chat
    this.scrollToBottom();
  }

  // function to hide the new message badge
  hideBadge() {
    if (this.hasTokenValue) {
      const badge = document.querySelector(`#recipient_${this.tokenValue} .new-message-badge`);
      if (badge) {
        badge.style.display = "none";
      }
    }
  }

  // function to scroll the chat to the bottom
  scrollToBottom() {
    if (this.hasMessagesContainerTarget) {
      this.messagesContainerTarget.scrollTop = this.messagesContainerTarget.scrollHeight;
    }
  }
}
