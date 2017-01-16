require_relative 'Data/visa'
require_relative 'Data/master_card'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite://' + Dir.pwd + '/test.db')
DataMapper.finalize
DataMapper.auto_migrate!

#=begin
c1 = Visa.create(
		:card_number     => "1234 4321-1234_4321",
		:cardholder_name => "QWE",
		:balance         => 0.0,
		:security_code   => "4565"
)
#=end
card = Visa.get_card_form_db('1234 4321-1234_4321')
p card
p card.check_access('4565')