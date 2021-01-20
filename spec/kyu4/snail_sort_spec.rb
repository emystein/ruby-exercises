require 'kyu4/snail_sort'

describe 'SquareMatrix.snail_sorted' do
  it 'snail snort empty' do
    matrix = SquareMatrix.new([[]])

    expect(matrix.snail_sorted).to eq([])
  end
  it 'snail snort 1 x 1 matrix' do
    matrix = SquareMatrix.new([[1]])

    expect(matrix.snail_sorted).to eq([1])
  end
  it 'snail snort 2 x 2 matrix' do
    matrix = SquareMatrix.new([[1, 2], [3, 4]])

    expect(matrix.snail_sorted).to eq([1, 2, 4, 3])
  end
  it 'snail snort 3 x 3 matrix' do
    matrix = SquareMatrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.snail_sorted).to eq([1, 2, 3, 6, 9, 8, 7, 4, 5])
  end
end

describe 'SquareMatrix.reduce' do
  it 'reduce 3 x 3 matrix to 1 x 1 matrix' do
    matrix = SquareMatrix.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]])

    expect(matrix.reduced).to eq(SquareMatrix.new([[5]]))
  end
end
