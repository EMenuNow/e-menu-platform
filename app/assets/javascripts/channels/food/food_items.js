App.snippets = App.cable.subscriptions.create(
  {
    channel: "FoodItemsChannel",
    restaurant_id: document.getElementById("restaurant_id").value,
  },

  {
    connected: function (data) {
      console.log("Connected to FoodItemsChannel!");
    },

    disconnected: function (data) {
      console.log("Disonnected from FoodItemsChannel!");
    },

    received: function (data) {
      console.log("Received data from FoodItemsChannel");
      $.ajax({
        url: window.location.href,
        type: "get",
        data: filterParams,
        success: function (response) {
          var orderData = $(response).find("#current-orders").html();
          var totalOrderCount = $(response).find("#total-order-count").text();
          $("#current-orders").html(orderData);
          $("#status-order-count").text(totalOrderCount);
          $(".modal").modal("hide");
          $("body").removeClass("modal-open");
          $("body").css("padding-right", "");
          $(".modal-backdrop").remove();
          $("#order-progress-overlay").removeClass("active");
          $(".lds-ellipsis").removeClass("active");

          $('.order-progress').on('ajax:send', function(ev) {
            $('#order-progress-overlay').addClass("active");
            $('.lds-ellipsis').addClass("active");
          });

        },

        error: function (xhr) {
          console.log(xhr);
        },

      });

      if (data.message == "New") {
        order_bell.play();
        setTimeout((order_bell.currentTime = 0), 1000);
      };

    },

  },

);
