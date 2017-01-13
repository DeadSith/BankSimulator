require 'data_mapper'
require_relative 'credit_card'
class Transaction
	include DataMapper::Resource
	property :id,   Serial
	property :sum,  Float,  :required => true
	
	belongs_to :sender,   'CreditCard',
			:parent_key => [:id],
			:child_key  => [:sender_id],
			:required => true
	
	belongs_to :receiver, 'CreditCard',
			:parent_key => [:id],
			:child_key  => [:receiver_id],
			:required => true
end