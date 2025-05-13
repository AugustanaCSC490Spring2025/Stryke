importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyD77a3ygmsa6NdCfRLuUQGY6gtWsUxFMc4',
  authDomain: 'stryke-30afd.firebaseapp.com',
  projectId: 'stryke-30afd',
  messagingSenderId: '430644823856',
  appId: '1:430644823856:web:4099472d41c5d783bbeaf5'
});

const messaging = firebase.messaging();
