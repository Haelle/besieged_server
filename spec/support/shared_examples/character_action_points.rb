RSpec.shared_examples 'character payed the AP cost' do
  it 'decrement character action points by one' do
    expect { subject; character.reload }.to change(character, :action_points).by(-1)
  end
end

RSpec.shared_examples 'character did not pay the AP cost' do
  it 'does not decrement character action point' do
    expect { subject; character.reload }.not_to change(character, :action_points)
  end
end
