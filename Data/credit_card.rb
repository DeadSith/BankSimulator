require 'data_mapper'
require 'dm-transactions'
require 'digest/sha2'
require_relative 'card_transaction'
class CreditCard
	include DataMapper::Resource
	property :id,               Serial
	property :card_number, String, :required => true, :length => 64
	property :cardholder_name,  String, :required => true
	property :balance,          Float,  :required => true
	property :security_code,    String, :required => true,  :length => 64
	property :type,             Discriminator
	
	has n, :sent_transactions,      'CardTransaction',
			:parent_key => [:id],
			:child_key  => [:sender_id]
	has n, :received_transactions,  'CardTransaction',
			:parent_key => [:id],
			:child_key  => [:receiver_id]
		
	def self.create(attributes)
		card_number              = attributes[:card_number].gsub(/[\s\-_]+/, '')
		unless card_number.length == 16 || card_number.scan(/\D/).empty?
			raise ArgumentError, 'Wrong credit card number'
		end
		attributes[:card_number] = Digest::SHA2.hexdigest card_number
		attributes[:security_code]    = Digest::SHA2.hexdigest attributes[:security_code]
		super(attributes)
	end
	
	def self.get_card_form_db(number)
		card_number = number.gsub(/[\s\-_]+/,'')
		unless card_number.length == 16 || card_number.scan(/\D/).empty?
			return nil
		end
		encrypted_number = Digest::SHA2.hexdigest card_number
		self.first(:card_number => encrypted_number)
	end
	
	def check_access(security_code)
		encrypted_code = Digest::SHA2.hexdigest security_code
		encrypted_code == self.security_code
	end
	
	def + (other)
		unless other.is_a?(Integer)||other.is_a?(Float)
			raise ArgumentError, 'Only Int or Float supported'
		end
		update(:balance => self.balance + other)
		self
	end
	
	def - (other)
		unless other.is_a?(Integer)||other.is_a?(Float)
			raise ArgumentError, 'Only Int or Float supported'
		end
		update(:balance => self.balance - other)
		self
	end
	
	def transfer(other, sum)
		unless sum.is_a?(Integer)||sum.is_a?(Float)
			raise ArgumentError, 'Only Int or Float supported'
		end
		unless other.is_a?(CreditCard)
			raise ArgumentError, 'You can only transfer money to other card'
		end
		unless sum < self.balance
			raise ArgumentError, 'Balance is too low'
		end
		CreditCard.transaction do |t|
			self.update( :balance => self.balance  - sum)
			other.update(:balance => other.balance + sum)
			tr = CardTransaction.create(
															:sum => sum,
															:sender => self,
			                        :receiver => other
			)
		end
	end
end