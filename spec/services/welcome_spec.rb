require 'spec_helper'

describe 'Welcome', type: :service do
  it 'adds 1 + 1' do
    expect(1 + 1).to eq(2)
  end

  it 'is running in the test environment' do
    expect(Rails.env.test?).to eq(true)
  end
end
