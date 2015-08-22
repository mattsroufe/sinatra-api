app = (function () {
  var init = function () {
    document.getElementById("login-form").addEventListener('submit', function (event) {
      var xhr = new XMLHttpRequest();
      xhr.open("POST", "/auth");
      xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
      xhr.send(JSON.stringify({
        email:    document.getElementById("email").value,
        password: document.getElementById("password").value
      }));
      event.preventDefault();
    });
  };

  return {
    init: init
  }
})();
