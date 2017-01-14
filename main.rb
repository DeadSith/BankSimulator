require_relative 'Data/credit_card'
require_relative 'Data/transaction'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite://' + Dir.pwd + '/test.db')
DataMapper.finalize
DataMapper.auto_upgrade!
