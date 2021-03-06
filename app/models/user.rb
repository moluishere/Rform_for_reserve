# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end
  validates :password, length: { minimum: 6, message: "密碼長度需大於6碼" }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: { message: "信箱錯誤"}
  has_many :surveys, -> { order(position: :asc) } , :dependent => :destroy
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  has_many :orders

  def status
    self.orders.to_a.select { |e| e.status == "paid"} == [] ?  "free" : "pro"
  end
end
