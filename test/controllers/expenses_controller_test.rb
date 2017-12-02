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
    post '/expenses', params: { expense: {type_id: 1, category_id: 2, date: '2017-11-26', amount: 3000, concept: 'Yao Ming'}}, xhr: true
    assert_response :success
  end

  test "patch update: is successful" do
    patch "/expenses/#{expenses(:expense_1).id}", params: { expense: {type_id: 1, category_id: 2, date: '2017-11-26', amount: 5000, concept: 'Try-testing'}}, xhr: true
    assert_response :success
  end

  test "delete expense: is successful" do
    delete "/expenses/#{expenses(:expense_1).id}", xhr: true
    assert_response :success
  end

  # test "user get index" do
    # visit '/'
    # click_link "New Expense"
    # fill_in "Type", with: types(:type_1).name
    # fill_in "Date", with: "11/26/2017"
    # fill_in "Category", with: categories(:category_1).name
    # fill_in "Concept", with: "Hola! comoe stas?"
    # click_button "Create expense"
  # end

end
