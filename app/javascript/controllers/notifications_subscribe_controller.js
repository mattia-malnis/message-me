import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { apiKey: Array };

  async connect() {
    try {
      if (this.hasApiKeyValue && "serviceWorker" in navigator && "PushManager" in window) {
        const registration = await this.registerServiceWorker();
        await this.registerPushSubscription(registration);
      } else {
        console.warn("Push notifications are not supported in this browser.");
      }
    } catch (error) {
      console.error("Error during service worker setup:", error);
    }
  }

  async registerServiceWorker() {
    try {
      const registration = await navigator.serviceWorker.register("/service-worker.js");
      return registration;
    } catch (err) {
      console.error("Unable to register service worker.", err);
      throw err;
    }
  }

  async registerPushSubscription(registration) {
    try {
      const apiKey = new Uint8Array(this.apiKeyValue);
      const subscribeOptions = {
        userVisibleOnly: true,
        applicationServerKey: apiKey,
      };

      const pushSubscription = await registration.pushManager.subscribe(subscribeOptions);

      const {
        endpoint,
        keys: { p256dh, auth },
      } = pushSubscription.toJSON();
      const subscriptionDetails = {
        subscription: { endpoint, p256dh_key: p256dh, auth_key: auth },
      };

      await this.sendSubscriptionToServer(subscriptionDetails);
    } catch (error) {
      console.error("Failed to subscribe the user to push notifications:", error);
    }
  }

  async sendSubscriptionToServer(subscriptionDetails) {
    try {
      const response = await fetch("/subscribe", {
        method: "POST",
        body: JSON.stringify(subscriptionDetails),
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (!response.ok) {
        throw new Error("Failed to send subscription to server");
      }
    } catch (error) {
      console.error("Failed to send subscription to the server:", error);
    }
  }
}
