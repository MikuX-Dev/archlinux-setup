// script.js

document.addEventListener("DOMContentLoaded", function() {
  // Code to run after the document has finished loading
  console.log("Script loaded successfully!");

  // Example event listener for a button click
  var button = document.getElementById("myButton");
  button.addEventListener("click", function() {
    alert("Button clicked!");
  });

  // Example function to handle form submission
  var form = document.getElementById("myForm");
  form.addEventListener("submit", function(event) {
    event.preventDefault(); // Prevent the form from submitting

    var nameInput = document.getElementById("name");
    var emailInput = document.getElementById("email");

    var name = nameInput.value;
    var email = emailInput.value;

    // Validate the form inputs
    if (name.trim() === "" || email.trim() === "") {
      alert("Please fill in all fields.");
    } else {
      // Submit the form or perform further processing
      alert("Form submitted successfully!");
      // You can make an AJAX request or perform any other necessary actions here
    }
  });
});
