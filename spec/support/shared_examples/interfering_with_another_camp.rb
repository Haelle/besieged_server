RSpec.shared_examples 'interfering with another camp' do
  it { is_expected.to be_failure }

  its([:error]) { is_expected.to eq "character (#{character.id}) does not belong to the camp (#{camp.id})" }

  it 'does not persist a character action' do
    expect { subject }.not_to change(CharacterAction, :count)
  end
end
