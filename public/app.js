app = (function () {
  var init = function () {
    fetch('/customers', {
      method: 'get'
    }).then(function(response) {
      return response.json();
    }).then(function(json) {
      console.log(json); 
    });
  };

  return {
    init: init
  }
})();
