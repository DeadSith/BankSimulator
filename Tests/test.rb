require_relative '../Data/credit_card'
require_relative '../Data/transaction'
require_relative '../Data/visa'
require_relative '../Data/master_card'

require 'microtest'
require 'microtest/assertions'

class CardTest
	def setup
		DataMapper::Logger.new($stdout, :debug)
		DataMapper.setup(:default, 'sqlite://' + Dir.pwd + '/test.db')
		DataMapper.finalize
		DataMapper.auto_migrate!
		
		c1 = Visa.create(
				:SHA1_card_number => "123",
				:cardholder_name => "QWE",
				:balance => 0.0,
				:security_code => "4565"
		)
		c2 = MasterCard.create(
				:SHA1_card_number => "14523",
				:cardholder_name => "DFG",
				:balance => 10.0,
				:security_code => "hghg"
		)
		tr = Transaction.create(
				:sum => 3.0,
				:sender => c2,
				:receiver => c1
		)
	end
	
	def test_visa_card
		card = CreditCard.first
		assert_equal('This is Visa card owned by QWE, current balance is 0.0',card.to_s)
	end
end

begin
	card += "str"
rescue ArgumentError => e
	puts e
end
p card.received_transactions[0].sum
transaction = Transaction.first
p transaction.sender.cardholder_name