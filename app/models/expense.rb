class Expense < ApplicationRecord
  belongs_to :type
  belongs_to :category

  validates :concept, :date, :amount, presence: true
  validate :date_cannot_be_in_the_future
  validates :amount, numericality: {greater_than_or_equal_to: 0}

  scope :find_category, ->(category) {Expense.where("category_id = ?", category)}
  scope :find_type, ->(type) {Expense.where("type_id = ?", type)}
  scope :find_month, ->(month) {Expense.where('extract(month from date) = ?', month)}
  scope :find_year, ->(year) {Expense.where('extract(year from date) = ?', year)}
  scope :last_6_months, -> {Expense.where("date >= :start_date AND date <= :end_date",{start_date: DateTime.now.months_ago(6).at_beginning_of_month, end_date: DateTime.now.at_end_of_month})}

  def date_cannot_be_in_the_future
    if date != nil
      errors.add(:date, "can't be in the future") if date.to_date > Date.today
    end
  end

end
