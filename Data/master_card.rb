require_relative 'credit_card'

class MasterCard < CreditCard
	def to_s
		"This is MasterCard card owned by #{cardholder_name}, current balance is #{balance}"
	end
end