$(document).on("turbolinks:load", function() {
  $(".master_check_box").click(function() {
    $(".check_box").prop("checked", $(this).prop("checked"));
  });
  $("input[type=submit]").click(function() {
    $("input[type=submit]").removeAttr("disabled");
  });
});
