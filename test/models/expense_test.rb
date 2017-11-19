require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase

  test "expense is not saved without a concept" do
    expense = Expense.new(date: DateTime.now, amount: 3000, category: categories(:category_1), type: types(:type_1))
    assert_not expense.save, "Expense is saved without a concept"
  end
  test "expense is not saved without a date" do
    expense = Expense.new(concept: 'Fred es di best', amount: 3000, category: categories(:category_1), type: types(:type_1))
    assert_not expense.save, "Expense is saved without a date"
  end
  test "expense is not saved without a amount" do
    expense = Expense.new(date: DateTime.now, concept: 'Cat cat cat', category: categories(:category_1), type: types(:type_1))
    assert_not expense.save, "Expense is saved without a amount"
  end
  test "expense is not saved  with a negative amount" do
    expense = Expense.new(amount: -3000, date: DateTime.now, concept: 'Cat cat cat', category: categories(:category_1), type: types(:type_1))
    assert_not expense.save, "Expense is saved with a negative amount"
  end

end
