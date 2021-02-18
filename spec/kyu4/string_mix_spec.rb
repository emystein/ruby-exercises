require 'kyu4/string_mix'
require 'rspec-parameterized'

describe 'string mix' do
  where(:string1, :string2, :expected) do
    [
      ['looping is fun but dangerous', 'less dangerous than coding', '1:ooo/1:uuu/2:sss/=:nnn/1:ii/2:aa/2:dd/2:ee/=:gg'],
      ['In many languages', "there's a pair of functions", '1:aaa/1:nnn/1:gg/2:ee/2:ff/2:ii/2:oo/2:rr/2:ss/2:tt'],
      ['Lords of the Fallen', 'gamekult', '1:ee/1:ll/1:oo'],
      ['codewars', 'codewars', ''],
      ['A generation must confront the looming ', 'codewarrs', '1:nnnnn/1:ooooo/1:tttt/1:eee/1:gg/1:ii/1:mm/=:rr']
    ]
  end

  with_them do
    it 'mix' do
      expect(mix(string1, string2)).to eq(expected)
    end
  end
end
