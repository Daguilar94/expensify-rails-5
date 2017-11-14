
const ready = function(){
  window.onload = function () {
    var chart = new CanvasJS.Chart("expenses-chart", $('.monthly').data('chart'))
    chart.render();
    var chart1 = new CanvasJS.Chart("daily-expenses-chart", $('.daily').data('chart'))
    chart1.render();
    var chart2 = new CanvasJS.Chart("category-chart", $('.category').data('chart'))
    chart2.render();
    var chart3 = new CanvasJS.Chart("month-acc", $('.accum').data('chart'))
    chart3.render();
  }
}
$(document).ready(ready)
$(document).on('page:change', ready)
