/* Firebase Cloud Messaging service worker: receives announcement pushes and
 * shows them as browser notifications while the site is closed or in a
 * background tab. Loaded automatically by the firebase_messaging plugin,
 * which registers /firebase-messaging-sw.js at the site root. */
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-messaging-compat.js');

/* Same web app config as lib/firebase_options.dart (public identifiers, not
 * secrets). */
firebase.initializeApp({
  apiKey: 'AIzaSyBcoH3QzkT1rjp5B6rRLFapinAhA__4pAE',
  appId: '1:471185690405:web:69d2a096be17e2e26b14cc',
  messagingSenderId: '471185690405',
  projectId: 'walk-and-discover-73c11',
  authDomain: 'walk-and-discover-73c11.firebaseapp.com',
  storageBucket: 'walk-and-discover-73c11.firebasestorage.app',
});

const messaging = firebase.messaging();

/* Notification-type messages are shown automatically by the browser; this
 * handler covers data-only messages so nothing is silently dropped. */
messaging.onBackgroundMessage((payload) => {
  const title = (payload.notification && payload.notification.title) ||
      (payload.data && payload.data.title) || 'Walk & Discover';
  const body = (payload.notification && payload.notification.body) ||
      (payload.data && payload.data.body) || '';
  self.registration.showNotification(title, { body: body, dir: 'rtl', lang: 'ar' });
});

/* Clicking the notification focuses the site if a tab is already open,
 * otherwise opens a new one. */
self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  event.waitUntil(clients.matchAll({ type: 'window', includeUncontrolled: true }).then((tabs) => {
    for (const tab of tabs) {
      if ('focus' in tab) return tab.focus();
    }
    return clients.openWindow('/');
  }));
});
