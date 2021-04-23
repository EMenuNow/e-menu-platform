//console.log("Connecting to channel: WordOfTheDayChannel")
App.snippets = App.cable.subscriptions.create(
 {
  channel: "KitchensChannel",
  restaurant_id: document.getElementById("restaurant_id").value,
 },
 {
  connected: function (data) {
   console.log("Connected to KitchensChannel!");

   //console.log(data);
  },
  disconnected: function (data) {
   console.log("Disonnected from KitchensChannel!");
   // console.log(data);
  },
  received: function (data) {
    // console.log(data);
    console.log("Received data from KitchensChannel");
    $("#current-orders").html(data.html);
    if (data.message == "New") {
      order_bell.play();
      setTimeout((order_bell.currentTime = 0), 1000);
    }

   // console.log("Data received: " + data)

   // console.log(data);
  },
 }
);
