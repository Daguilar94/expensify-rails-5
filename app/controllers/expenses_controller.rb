class ExpensesController < ApplicationController
  respond_to :html, :js
  # respond_to :js

  def index
    @categories = Category.all
    @types = Type.all
    @months = generate_months

    @current_month = @months[params[:date].to_i]

    type_id = params[:type_id] unless params[:type_id] == ''
    category_id = params[:category_id] unless params[:category_id] == ''
    month = @current_month.month
    year = @current_month.year

    # puts "CURRENT MONTH: #{@current_month}"
    # puts "MONTH: #{@current_month.month}"
    # puts "YEAR: #{@current_month.year}"
    # puts "TYPE_ID: #{type_id}"
    # puts "CATEGORY_ID: #{category_id}"

    if category_id == nil && type_id == nil
      puts 'SIN FILTRO'
      @expenses = Expense.find_year(year).find_month(month)
    end
    if (category_id != nil && type_id != nil)
      puts "CATEGORY:#{category_id} Y TYPE: #{type_id} AMBOS"
      @expenses = Expense.find_year(year).find_month(month).find_category(category_id).find_type(type_id)
    end
    if (category_id != nil && type_id == nil)
      puts "CATEGORY:#{category_id} Y TYPE: #{type_id} SOLO CATEGORY"
      @expenses = Expense.find_year(year).find_month(month).find_category(category_id.to_i)
    end
    if (category_id == nil && type_id != nil)
      puts "CATEGORY:#{category_id} Y TYPE: #{type_id} SOLO TYPE"
      @expenses = Expense.find_year(year).find_month(month).find_type(type_id.to_i)
    end

    respond_to do |format|
      format.js
      format.html
    end

  end

  def new
    @expense = Expense.new
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @expense = Expense.new safe_params
    if @expense.save
      flash[:success] = "Expense successfully created"
      puts 'Se creo el expense'
      # flash[:success] = "Expense successfully created"
      redirect_to expenses_path
    else
      render :new
    end
  end

  protected

  def safe_params
    params.require(:expense).permit(:type_id, :date, :category_id, :concept, :amount)
  end

end
