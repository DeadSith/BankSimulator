require_relative '../Data/credit_card'
require_relative '../Data/transaction'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite://' + Dir.pwd + '/task_manager.db')
DataMapper.finalize

def create_test_date
	c1 = CreditCard.create(
			:SHA1_card_number => "123",
			:cardholder_name => "QWE",
			:balance => 0.0,
			:security_code => "4565"
	)
	c2 = CreditCard.create(
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

#create_test_date
card = CreditCard.first
p card.received_transactions[0].sum
transaction = Transaction.first
p transaction.sender.cardholder_name