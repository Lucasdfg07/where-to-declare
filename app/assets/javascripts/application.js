//= require jquery
//= require jquery_ujs
//
//= require turbolinks
//= require materialize-sprockets
//= require_tree .

$(document).ready(function() {
    $('select').material_select();
    $('.datepicker').datepicker();
});