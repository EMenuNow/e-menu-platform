//console.log("Connecting to channel: WordOfTheDayChannel")
App.snippets = App.cable.subscriptions.create(
 {
  channel: "FoodItemsChannel",
  restaurant_id: document.getElementById("restaurant_id").value,
 },
 {
  connected: function (data) {
    console.log("Connected to FoodItemsChannel!");
    //console.log(data);
  },
  
  disconnected: function (data) {
    console.log("Disonnected from FoodItemsChannel!");
    // console.log(data);
  },

  received: function (data) {
    console.log("Received data from FoodItemsChannel");
    $(".modal").modal('hide');
    $("body").removeClass("modal-open");
    $("body").css("padding-right","");
    $(".modal-backdrop").remove();
    $("#order-progress-overlay").removeClass("active");
    $(".lds-ellipsis").removeClass("active");
    $("#current-orders").html(data.html);
    if (data.message == "New") {
      order_bell.play();
      setTimeout((order_bell.currentTime = 0), 1000);
    }

    $('.order-progress').on('ajax:send', function(ev) {
      $('#order-progress-overlay').addClass("active");
      $('.lds-ellipsis').addClass("active");
    })

   // alert('FoodItemsChannel Broacacast')

   // console.log("Data received: " + data)

   // console.log(data);
  },
 }
);
