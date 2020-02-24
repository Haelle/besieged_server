RSpec.shared_examples 'CharacterAction saved' do |action_type|
  its([:action]) { is_expected.to be_a CharacterAction }
  its([:action]) { is_expected.to be_persisted }

  it 'logs the action from character' do
    expect(subject[:action].character).to eq character
  end

  it 'logs the action on camp' do
    expect(subject[:action].camp).to eq camp
  end

  it 'logs the action type' do
    expect(subject[:action].action_type).to eq action_type
  end

  it 'logs the action params' do
    expect(subject[:action].action_params).to eq action_params
  end

  it 'logs the action target' do
    expect(subject[:action].target).to eq target
  end
end
