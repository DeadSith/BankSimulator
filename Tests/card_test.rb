require_relative 'test_helper'

class CardTest < Minitest::Test
  def setup
    DataMapper.setup(:default, 'sqlite://' + Dir.pwd + '/test.db')
    DataMapper.finalize
    DataMapper.auto_migrate!
    Visa.create(
        :card_number     => "1234 4321-1234_4321",
        :cardholder_name => "QWE",
        :balance         => 0.0,
        :security_code   => "4565"
    )
    MasterCard.create(
        :card_number     => "1452321167879002",
        :cardholder_name => "DFG",
        :balance         => 10.0,
        :security_code   => "hghg"
    )
  end
  
  def test_creation
    visa = Visa.first
    master = MasterCard.first
    assert_equal(visa.card_number.length,64)&&
        assert_equal(visa.security_code.length,64)&&
        assert_equal(master.card_number.length,64)&&
        assert_equal(master.security_code.length,64)
  end
  
  def test_find_and_access
    card = Visa.get_card_form_db('1234432112344321')
    assert(card)&&
        assert(card.check_access('4565'))&&
        assert(!card.check_access('qew'))
  end
  
  def test_visa_card
    card = CreditCard.first
    assert_equal('This is Visa card owned by QWE, current balance is 0.0',card.to_s)
  end
  
  def test_add
    card = CreditCard.first
    card += 5
    #card.save
    card = CreditCard.first
    assert_equal(card.balance, 5.0)
  end
  
  def test_subtract
    card = CreditCard.first
    card -= 5
    card.save
    card = CreditCard.first
    assert_equal(card.balance, -5.0)
  end
  
  def test_incorrect_add
    a = CreditCard.first
    assert_raises{
      a+='str'
    }
  end
  
  def test_transaction
    card = CreditCard.first
    master = MasterCard.first
    master.transfer(card,3)
    assert_equal(card.received_transactions[0],master.sent_transactions[0])&&
        assert_equal(card.received_transactions[0].sum,card.balance)
  end
  
  def test_incorrect_transaction
    visa = CreditCard.first
    master = MasterCard.first
    assert_raises{
      master.transfer(visa,'123')
    }&&
    assert_raises{
      master.transfer('123',2)
    }&&
    assert_raises{
      visa.transfer(master,5)
    }
  end
end