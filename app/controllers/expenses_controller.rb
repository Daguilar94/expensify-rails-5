class ExpensesController < ApplicationController
  respond_to :html, :js

  def index
    @tab = :expenses
    @categories = Category.all
    @types = Type.all
    @months = generate_last_n_months (12)

    @current_month = @months[params[:date].to_i]

    type_id = params[:type_id] unless params[:type_id] == ''
    category_id = params[:category_id] unless params[:category_id] == ''
    month = @current_month.month
    year = @current_month.year

    if category_id == nil && type_id == nil
      @expenses = Expense.find_year(year).find_month(month).order(date: :desc)
    end
    if (category_id != nil && type_id != nil)
      @expenses = Expense.find_year(year).find_month(month).find_category(category_id).find_type(type_id).order(date: :desc)
    end
    if (category_id != nil && type_id == nil)
      @expenses = Expense.find_year(year).find_month(month).find_category(category_id.to_i).order(date: :desc)
    end
    if (category_id == nil && type_id != nil)
      @expenses = Expense.find_year(year).find_month(month).find_type(type_id.to_i).order(date: :desc)
    end

    respond_to do |format|
      format.js
      format.html { render 'index'}
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
    @categories = Category.all
    @types = Type.all
    @expense = Expense.new safe_params
    @alert_msg = ''
    if @expense.save
      @alert_msg = 'Expense successfully created'
    else
      render :new
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
    @expense = Expense.find params[:id]
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    @categories = Category.all
    @types = Type.all
    @alert_msg = ''
    @expense = Expense.find params[:id]
    @old_amount = @expense.amount
    if @expense.update safe_params
      @alert_msg = 'Expense successfully updated'
      # flash[:success] = "Expense successfully updated"
    else
      render :edit
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def destroy
    @alert_msg = ''
    @expense = Expense.find params[:id]
    @expense.destroy
    @alert_msg = 'Expense successfully deleted'
    # flash[:success] = "Expense successfully deleted"
  end

  protected

  def safe_params
    params.require(:expense).permit(:type_id, :date, :category_id, :concept, :amount)
  end

end
