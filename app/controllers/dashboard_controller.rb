class DashboardController < ApplicationController
  respond_to :html, :js

  def index
    @tab = :dashboard

    #Set up variables for controller method

    last_6_months = generate_last_n_months (6)
    last_6_months_expenses = Expense.last_6_months # petición 1 a la base de datos
    all_types = Type.all # petición 1 a la base de datos
    all_categories = Category.all # petición 3 a la base de datos
    actual_accum = 0
    last_accum = 0
    date_tree = {}
    month_totals = {}
    day_totals_current_month = []
    day_totals_last_month = []
    category_totals = []
    @actual_month_amount = 0
    @last_month_amount = 0

    #Set up month_totals, day_totals_current_month, day_totals_last_month, category_totals and date_tree variables

    last_6_months.each do |m|
      date_tree[m.strftime('%b-%Y')] = last_6_months_expenses.find_all {|ex| ex.date.month == m.month }
      month_totals[m.strftime('%b-%Y')] = {}
      all_types.length.times do |i|
        month_totals[m.strftime('%b-%Y')][i+1] = 0
      end
    end

    DateTime.now.day.times do |i|
      day_totals_current_month[i] = 0
    end

    DateTime.now.months_ago(6).at_end_of_month.day.times do |i|
      day_totals_last_month[i] = 0
    end

    all_categories.length.times do |i|
      category_totals[i] = 0
    end

    #Fill month_totals and day_totals_current_month, category_totals and day_totals_last_month variables

    6.times do |i|
      date_tree[last_6_months[i].strftime('%b-%Y')].each do |element|
        month_totals[last_6_months[i].strftime('%b-%Y')][element.type_id] += element.amount
        if i == 0
          @actual_month_amount += element.amount
          day_totals_current_month[element.date.day-1] += element.amount
          category_totals[element.category_id-1] += element.amount
        end
        if i == 1
          day_totals_last_month[element.date.day-1] += element.amount
          @last_month_amount += element.amount
        end
      end
    end

    @today_amount = day_totals_current_month[DateTime.now.day-1]
    @yesterday_amount = day_totals_current_month[DateTime.now.day-2]


    # CHART-1 ---------------------------------------------

    @options_1 = {
      animationEnabled: true,
      backgroundColor: '#303336',
      legend:{
        fontColor: "#999"
      },
      axisX: {
        interval: 1,
        labelFontColor: "#999",
        lineThickness: 1,
        lineColor: "#555"
      },
      axisY: {
        prefix: "$",
        interval: 10000000,
        labelFontColor: "#999",
        gridColor: "#555",
        gridThickness: 1,
        lineThickness: 1,
        lineColor: "#555"
      },
      data: []
    }

    # end CHART-1 ---------------------------------------------
    # CHART-2 -------------------------------------------------

    @options_2 = {
      animationEnabled: true,
      backgroundColor: '#303336',
      axisX: {
        interval: 1,
        labelFontColor: "#999",
        lineThickness: 1,
        lineColor: "#555"
      },
      axisY: {
        prefix: "$",
        interval: 3000000,
        labelFontColor: "#999",
        gridColor: "#555",
        gridThickness: 1,
        lineThickness: 1,
        lineColor: "#555"
      },
      data: [{
        type: "column",
        name: "Totals",
        dataPoints: []
        }]
      }

      # end CHART-2 ---------------------------------------------
      # CHART-3 -------------------------------------------------

      @options_3 = {
        animationEnabled: true,
        backgroundColor: '#303336',
        data: [
          {
            indexLabelFontColor: "#999",
            indexLabelLineColor: "#999",
            indexLabelPlacement: "outside",
            type: "doughnut",
            dataPoints: []
          }
        ]
      }

      # end CHART-3 ---------------------------------------------
      # CHART-4 -------------------------------------------------

      @options_4 = {
        animationEnabled: true,
        backgroundColor: '#303336',
        legend:{
          fontColor: "#999",
        },
        toolTip:{
          shared: true
        },
        axisX: {
          interval: 5,
          labelFontColor: "#999",
          lineThickness: 1,
          lineColor: "#555"
        },
        axisY: {
          prefix: "$",
          interval: 10000000,
          labelFontColor: "#999",
          gridColor: "#555",
        gridThickness: 1,
        lineThickness: 1,
        lineColor: "#555"
        },
        data:
        [
          {
            type: "area",
            name: "Current month",
            color: "rgba(10,12,150,.8)",
            showInLegend: true,
            dataPoints: []
          },
          {
            type: "area",
            name: "Last month",
            color: "rgba(150,12,32,.8)",
            showInLegend: true,
            dataPoints: []
          }
        ]
      }

      # end CHART-4 -------------------------------------------------

      #Build data object for chart 1
      all_types.length.times do |i|
        data_helper =  {
          type: "stackedColumn",
          name: "#{all_types[i].name}",
          showInLegend: true,
        }
        dataPoints = generate_dataPoints_chart_1(i, last_6_months, month_totals)
        data_helper[:dataPoints] = dataPoints
        @options_1[:data] << data_helper
      end
      @options_1 = @options_1.to_json

      #Build data object for chart 2 and part of the chart 4
      day_totals_current_month.each_with_index do |element, index|
        actual_accum += element
        point = {label: index+1, y: element}
        point1 = {label: index+1, y: actual_accum}
        @options_2[:data][0][:dataPoints] << point
        @options_4[:data][0][:dataPoints] << point1
      end
      @options_2 = @options_2.to_json

      #Build data object for chart 3
      category_totals.each_with_index do |element, index|
        point = {y: element, indexLabel: "#{all_categories[index].name}"}
        @options_3[:data][0][:dataPoints] << point
      end

      @options_3 = @options_3.to_json

      #Build data object for chart 4
      day_totals_last_month.each_with_index do |element, index|
        last_accum += element
        point = {label: index+1, y: last_accum}
        @options_4[:data][1][:dataPoints] << point
      end

      # respond_to do |format|
      #   format.html
      #   format.js
      # end

    end

    protected

    def generate_dataPoints_chart_1 (typeId, l6months, totals)
      result = []
      n = l6months.length
      n.times do |i|
        result << {label: l6months[i].strftime('%b-%Y'), y: totals[l6months[i].strftime('%b-%Y')][typeId+1]}
      end
      result
    end
  end
