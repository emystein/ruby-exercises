require 'digital_root'

describe "Digital Root" do
   it "0 reduces to 0" do
     expect(digital_root(0)).to eq 0
   end
   it "16 reduces to 7" do
     expect(digital_root(16)).to eq 7
   end
   it "942 reduces to 6" do
     expect(digital_root(942)).to eq 6
   end
end
