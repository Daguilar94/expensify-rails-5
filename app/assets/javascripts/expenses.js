
$(document).ready(function() {
  var url = {'type': '', 'category': '', 'date': ''}

  $(document).on('click','.list-group-item', function(e){
    e.preventDefault()
    $(this).siblings('.list-group-item').removeClass('visited')
    $(this).toggleClass('visited')
    build_url()
    $.ajax({
      type: "GET",
      url: `/expenses?type_id=${url.type}&category_id=${url.category}&date=${url.date}`,
      format: 'js'
    })
    .done(function(data) {
      console.log('Se realizó con éxito el llamado ajax!')
    })
  })
  $(document).on('click','.month-item', function(e){
    e.preventDefault()
    $('.month-item').removeClass('visited')
    $(this).addClass('visited')
    build_url()
    $.ajax({
      type: "GET",
      url: `/expenses?type_id=${url.type}&category_id=${url.category}&date=${url.date}`,
      format: 'js'
    }).done(function(data) {
        console.log('Se realizó con éxito el llamado ajax!')
    })
  })

  build_url = function() {
    $('.filter-type .list-group-item.visited').attr('tid') == undefined ? url.type = '' : url.type =
    $('.filter-type .list-group-item.visited').attr('tid')

    $('.filter-category .list-group-item.visited').attr('cid') == undefined ? url.category = '' : url.category = $('.filter-category .list-group-item.visited').attr('cid')

    $('.month-item.visited').attr('month_index') == undefined ? url.date = '' : url.date = $('.month-item.visited').attr('month_index')

    console.log(url)
  }
})