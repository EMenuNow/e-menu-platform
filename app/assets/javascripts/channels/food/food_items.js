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
   $("#current-orders").html(data.html);
    if (data.message == "New") {
      order_bell.play();
      setTimeout((order_bell.currentTime = 0), 1000);
    }

   $(".receipt-ready").on("confirm:complete", function (e) {
    if (e.originalEvent.detail[0]) {
     var receiptId = this.id.match(/\d+/);
     $(`#receipt-${receiptId}-card`).hide();
    }
   });
   // alert('FoodItemsChannel Broacacast')

   // console.log("Data received: " + data)

   // console.log(data);
  },
 }
);
