App.snippets = App.cable.subscriptions.create(
  {
    channel: "ReceiptsChannel",
    restaurant_id: document.getElementById("restaurant_id").value,
  },

  {
    connected: function (data) {
      console.log("Connected to ReceiptsChannel!");
    },

    disconnected: function (data) {
      console.log("Disonnected from ReceiptsChannel!");
    },

    received: function (data) {
      console.log("Received data from ReceiptsChannel");
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
          var totalOrderCount = $(response).find("#total-order-count").text();
          $("#current-orders").html(orderData);
          $("#status-order-count").text(totalOrderCount);
          $("#live-order").removeClass("mab-active");
          $("#order-progress-overlay").removeClass("active");
          $(".lds-ellipsis").removeClass("active");
          
          $('#check-all-orders').on('click', function() {    
            $('.check-order:checkbox').prop('checked', this.checked);    
          });

          $('.check-order').on('click', function() {
            var checkedOrderCount = $(".checked-order:checkbox:checked").length;
            if (checkedOrderCount > 0) {
              var n = new RegExp('^((\\S+ ){1})(\\S+)');
              var o = new RegExp('^((\\S+ ){2})(\\S+)');

              if (checkedOrderCount == 1 ) {
                $("#mab-order-count").text(`${checkedOrderCount} Order`);
                $(".mab-confirm").attr("data-confirm", (function(k,v) {return v.replace(n, `$1${checkedOrderCount}`);}));
                $(".mab-confirm").attr("data-confirm", (function(k,v) {return v.replace(o, `$1order`);}));
                $("#all-receipt").attr("data-confirm", `Re-send recipt for ${checkedOrderCount} order?`);
                } else {
                $("#mab-order-count").text(`${checkedOrderCount} Orders`);
                $(".mab-confirm").attr("data-confirm", (function(k,v) {return v.replace(n, `$1${checkedOrderCount}`);}));
                $(".mab-confirm").attr("data-confirm", (function(k,v) {return v.replace(o, `$1orders`);}));
                $("#all-receipt").attr("data-confirm", `Re-send recipt for ${checkedOrderCount} orders?`);
              };

              $("#live-multi-action-bar").addClass("active");
              $("#live-order").addClass("mab-active");

            } else {
              $("#mab-order-count").text(`0 Orders`);
              $("#live-multi-action-bar").removeClass("active");
              $("#live-order").removeClass("mab-active");
            };

          });

          $('#all-cancel').on('click', function() {
            $("#mab-order-count").text(`0 Orders`);
            $("#live-multi-action-bar").removeClass("active");
            $("#live-order").removeClass("mab-active");
            $('.check-order:checkbox').prop('checked', false);   
          });

          $('.order-progress').on('ajax:send', function(ev) {
            var $btn = $(document.activeElement);

            if ($btn.hasClass('no-broadcast')) {
              $("#mab-order-count").text(`0 Orders`);
              $("#live-multi-action-bar").removeClass("active");
              $("#live-order").removeClass("mab-active");
              $('.check-order:checkbox').prop('checked', false);    
              $('#order-progress-overlay').removeClass("active");
              $('.lds-ellipsis').removeClass("active");
            } else {
              $('#order-progress-overlay').addClass("active");
              $('.lds-ellipsis').addClass("active");
            };

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
