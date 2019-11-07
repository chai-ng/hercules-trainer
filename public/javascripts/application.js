document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.slider');
    var options = document.querySelectorAll('.slides');
    var instances = M.Slider.init(elems, options);
});

document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.fixed-action-btn');
    var options = document.querySelectorAll('.exercise-options');
    var instances = M.FloatingActionButton.init(elems, options);
  });

document.addEventListener('DOMContentLoaded', function() {
    var elems = document.querySelectorAll('.modal');
    var instances = M.Modal.init(elems);
});

$(document).ready(function(){
    $('.modal').modal();
    $('.tabs').tabs();
    $('.dropdown-trigger').dropdown();
    $('select').formSelect();
});

// var addSecond = function() {
//     $('.timer')[0].value = Number($('.timer')[0].value) + 1;
// }
// var timerID = 0;

// $('.timer-start')[0].addEventListener('click', function(){
//     timerID = setInterval(addSecond, 1000);
// });

// $('.timer-pause')[0].addEventListener('click', function(){
//     clearInterval(timerID);
// });
