require 'arrh_grab_scrab'

describe 'arrh_grab_scrab' do
    it 'filter sport, ports' do
        expect(grabscrab("ortsp", ["sport", "parrot", "ports", "matey"])).to eq ["sport", "ports"]
    end

    it 'filter all out' do
        expect(grabscrab("ourf", ["one","two","three"])).to eq []
    end
end