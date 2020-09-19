var firebaseConfig = {
    apiKey: "AIzaSyCYKbo4DMLlSxquWTUHZho9VJal2yrSfvw",
    authDomain: "homeroom-app.firebaseapp.com",
    databaseURL: "https://homeroom-app.firebaseio.com",
    projectId: "homeroom-app",
    storageBucket: "homeroom-app.appspot.com",
    messagingSenderId: "536792340424",
    appId: "1:536792340424:web:0312f3c5ea1e63469452fd",
    measurementId: "G-39HVSN6GC4"
  };

// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();
// Get a reference to the database service
var db = firebase.database();