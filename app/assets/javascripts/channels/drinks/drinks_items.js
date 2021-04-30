//console.log("Connecting to channel: WordOfTheDayChannel")
App.snippets = App.cable.subscriptions.create(
 {
  channel: "DrinkItemsChannel",
  restaurant_id: document.getElementById("restaurant_id").value,
 },
 {
  connected: function (data) {
   console.log("Connected to DrinkItemsChannel!");

   //console.log(data);
  },
  disconnected: function (data) {
   console.log("Disonnected from DrinkItemsChannel!");
   // console.log(data);
  },
  received: function (data) {
    console.log("Received data from DrinkItemsChannel");
    $(".modal").modal('hide');
    $("body").removeClass("modal-open");
    $("body").css("padding-right","");
    $(".modal-backdrop").remove();
    $("#current-orders").html(data.html);
    if (data.message == "New") {
      order_bell.play();
      setTimeout((order_bell.currentTime = 0), 1000);
    }
   // alert('DrinkItemsChannel Broacacast')

   // console.log("Data received: " + data)

   // console.log(data);
  },
 }
);
