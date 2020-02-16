require 'duplicate_count'

describe "Duplicate Count" do
   it "abcde counts 0" do
       expect(duplicate_count('abcde')).to eq 0
   end
   it "abcdeaa counts 1" do
       expect(duplicate_count('abcdeaa')).to eq 1
   end
   it "abcdeaB counts 2" do
       expect(duplicate_count('abcdeaB')).to eq 2
   end
end
