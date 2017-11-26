require 'test_helper'

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
  end

  test "get index: is successful" do
    get expenses_path, params: {type_id: 1, category_id: 3, date: 1}
    assert_response :success
  end

  test "get new_modal: is successful" do
    get new_expense_path
    assert_response :success
  end

  test "get edit_modal: is successful" do
    get "/expenses/#{expenses(:expense_1).id}/edit", xhr: true
    assert_response :success
  end

  test "post create: is successful" do
    post '/expenses', params: { expense: {type_id: 1, category_id: 2, date: '11/26/2017', amount: 3000, concept: 'Yao Ming'}}, xhr: true
    assert_response :success
  end
  
end
