//console.log("Connecting to channel: WordOfTheDayChannel")
App.snippets = App.cable.subscriptions.create(
 {
  channel: "KitchensChannel",
  restaurant_id: document.getElementById("restaurant_id").value,
 },

 {
  connected: function (data) {
   console.log("Connected to KitchensChannel!");
  },

  disconnected: function (data) {
   console.log("Disonnected from KitchensChannel!");
  },

  received: function (data) {
   console.log("Received data from KitchensChannel");
   $(".modal").modal("hide");
   $("body").removeClass("modal-open");
   $("body").css("padding-right", "");
   $(".modal-backdrop").remove();
   $.ajax({
    url: window.location.href,
    type: "get",
    data: filterParams,
    success: function (response) {
     var orderData = $(response).find("#current-orders").html();
     $("#current-orders").html(orderData);
    },
    error: function (xhr) {
     console.log(xhr);
    },
   });
   if (data.message == "New") {
    order_bell.play();
    setTimeout((order_bell.currentTime = 0), 1000);
   }
  },
 }
);
