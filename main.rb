require_relative 'Data/visa'
require_relative 'Data/master_card'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite://' + Dir.pwd + '/test.db')
DataMapper.finalize
DataMapper.auto_migrate!