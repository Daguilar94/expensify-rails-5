module Api
  module V1
    class ExpensesController < ApplicationController
      protect_from_forgery with: :null_session
      respond_to :json

      def index
        type_id = params[:type_id] unless params[:type_id] == ''
        category_id = params[:category_id] unless params[:category_id] == ''
        month = params[:month]
        year = params[:year]

        if category_id == nil && type_id == nil
          expenses = Expense.find_year(year).find_month(month).order(date: :desc)
        end
        if (category_id != nil && type_id != nil)
          expenses = Expense.find_year(year).find_month(month).find_category(category_id).find_type(type_id).order(date: :desc)
        end
        if (category_id != nil && type_id == nil)
          expenses = Expense.find_year(year).find_month(month).find_category(category_id.to_i).order(date: :desc)
        end
        if (category_id == nil && type_id != nil)
          expenses = Expense.find_year(year).find_month(month).find_type(type_id.to_i).order(date: :desc)
        end
        render json: expenses
      end

      def create
        expense = Expense.new(safe_params)
        if expense.save
          render json: expense, status: 201
        else
          render json: { errors: expense.errors }, status: 422
        end
      end

      def update
        expense = Expense.find(params[:id])
        if expense.update(safe_params)
          render json: expense, status: 200
        else
          render json: {errors: expense.errors}, status: 422
        end
      end

      def destroy
        expense = Expense.find(params[:id])
        expense.destroy
        head :no_content
      end

      private
      def safe_params
        params.require(:expense).permit(:type_id, :date, :category_id, :concept, :amount, :month, :year)
      end
    end
  end
end
