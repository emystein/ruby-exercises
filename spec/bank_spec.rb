require 'bank'

describe 'Bank' do
  before(:each) do
    @bank = Bank.new
  end

  describe 'BankAccount' do
    it 'has an owner' do
      account = @bank.create_account(owner: 'John Doe', constraints: NoConstraints.new)

      expect(account.owner).to eq 'John Doe'
    end
  end
end