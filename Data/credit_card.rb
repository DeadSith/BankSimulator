require 'data_mapper'
require_relative 'transaction'
class CreditCard
	include DataMapper::Resource
	property :id,               Serial
	property :SHA1_card_number, String, :required => true,  :length => 40
	property :cardholder_name,  String, :required => true
	property :balance,          Float,  :required => true
	property :security_code,    String, :required => true,  :length => 40
	
	has n, :sent_transactions,      'Transaction',
			:parent_key => [:id],
			:child_key  => [:sender_id]
	has n, :received_transactions,  'Transaction',
			:parent_key => [:id],
			:child_key  => [:receiver_id]
end