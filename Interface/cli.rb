require_relative '../Data/visa'
require_relative '../Data/master_card'


class Cli
	def initialize
		DataMapper::Logger.new($stdout, :debug)
		DataMapper.setup(:default, 'sqlite://' + Dir.pwd + '/test.db')
		DataMapper.finalize
		DataMapper.auto_migrate!
	end
	
	def work
		print 'Enter command or help to view available commands: '
		while (command = gets.chomp)!='q' do
			begin
				self.send(command)
				print 'Enter command or help to view available commands: '
			rescue => e
				print e.message
			end
		end
	end
	
	def add
		print "You are going to create new card.\nEnter card type(visa/mastercard): "
		type = gets.chomp.downcase
		case type
			when 'visa'
				Visa.create(read_card_attributes)
			when 'mastercard'
				MasterCard.create(read_card_attributes)
			else
				puts 'There is no such card. Rerun this command with correct input.'
		end
	end
	def delete
		print "You are going to delete card from database.\nEnter card number: "
		card = CreditCard.get_card_form_db(gets.chomp)
		if card
			print 'Enter security code: '
			if card.check_access(gets.chomp)
				card.destroy
			else
				puts 'Wrong security code.'
			end
		else
			puts 'No card with such number.'
		end
	end
	def change_balance
		print "You are going to change card balance.\nEnter card number: "
		card = CreditCard.get_card_form_db(gets.chomp)
		print 'Enter amount: '
		card += gets.chomp.to_i
	end
	def transfer
		puts "You are going to transfer money.\nEnter card to transfer from: "
		from = CreditCard.get_card_form_db(gets.chomp)
		puts 'Enter card to transfer to: '
		to = CreditCard.get_card_form_db(gets.chomp)
		puts 'Enter your security code: '
		if from.check_access(gets.chomp)
			puts 'Enter sum: '
			from.transfer(to, gets.chomp)
		else
			print 'Wrong security code.'
		end
	end
	private
	def read_card_attributes
		hash = {}
		puts 'Enter cardholder name: '
		hash[:cardholder_name] = gets.chomp
		puts 'Enter card number: '
		hash[:card_number] = gets.chomp
		puts 'Enter security code: '
		hash[:balance] = 0.0
		hash[:security_code] = gets.chomp
		hash
	end
end