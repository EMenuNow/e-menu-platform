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
   $("#current-orders").html(data.html);
   $("body").addClass("bg-danger");
   $("#accept-button").show();
   order_bell.play();
   setTimeout((order_bell.currentTime = 0), 1000);

   $(".receipt-ready").on("confirm:complete", function (e) {
    if (e.originalEvent.detail[0]) {
     var receiptId = this.id.match(/\d+/);
     $(`#receipt-${receiptId}-card`).hide();
    }
   });
   // alert('DrinkItemsChannel Broacacast')

   // console.log("Data received: " + data)

   // console.log(data);
  },
 }
);
