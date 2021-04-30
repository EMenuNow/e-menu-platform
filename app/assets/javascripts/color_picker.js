$(document).ready(function () {
 const colPrimary = $("#theme_color_primary");
 const colSecondary = $("#theme_color_secondary");

 colPrimary.on("keyup change", function () {
  setPrimary();
 });
 colSecondary.on("keyup change", function () {
  setSecondary();
 });

 function setPrimary() {
  $("#color_block_primary").css("background-color", colPrimary.val());
 }
 function setSecondary() {
  $("#color_block_secondary").css("background-color", colSecondary.val());
 }
});
