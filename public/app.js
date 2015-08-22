app = (function () {
  var init = function () {
    document.getElementById("login-form").addEventListener('submit', function (event) {
      var xhr = new XMLHttpRequest();
      xhr.open("POST", "/auth");
      xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      xhr.send(JSON.stringify({
        email:    document.getElementById("login-email").value,
        password: document.getElementById("login-password").value
      }));
      event.preventDefault();
    });

    document.getElementById("signup-form").addEventListener('submit', function (event) {
      var xhr = new XMLHttpRequest();
      xhr.open("POST", "/signup");
      xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      xhr.send(JSON.stringify({
        email:    document.getElementById("signup-email").value,
        password: document.getElementById("signup-password").value
      }));
      event.preventDefault();
    });
  };

  return {
    init: init
  }
})();
