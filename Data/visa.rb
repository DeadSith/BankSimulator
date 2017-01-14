require_relative 'credit_card'
require_relative 'transaction'
class Visa < CreditCard
	def to_s
		"This is Visa card owned by #{cardholder_name}, current balance is #{balance}"
	end
end