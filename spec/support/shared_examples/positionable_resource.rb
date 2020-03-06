RSpec.shared_examples 'positionable resource' do
  subject { described_class.next_position_vacancy camp }

  let(:camp) { create :camp }

  let(:factory_name) do
    described_class.name.split('::').second.underscore.to_sym
  end

  it 'returns 0 with an empty list' do
    expect(subject).to eq 0
  end

  it 'returns 3 without gap' do
    create factory_name, camp: camp, position: 0
    create factory_name, camp: camp, position: 1
    create factory_name, camp: camp, position: 2

    expect(subject).to eq 3
  end

  it 'returns 0 when missing only 0' do
    create factory_name, camp: camp, position: 1
    create factory_name, camp: camp, position: 2
    expect(subject).to eq 0
  end

  it 'returns 2 when missing only 2' do
    create factory_name, camp: camp, position: 0
    create factory_name, camp: camp, position: 1
    create factory_name, camp: camp, position: 3
    expect(subject).to eq 2
  end

  it 'returns 2 when missing 2 and 4' do
    create factory_name, camp: camp, position: 0
    create factory_name, camp: camp, position: 1
    create factory_name, camp: camp, position: 3
    create factory_name, camp: camp, position: 5
    expect(subject).to eq 2
  end
end

RSpec.shared_examples 'only one siege machine per position' do
  subject do
    described_class.new(
      camp: camp,
      position: position,
      damages: 2,
      name: 'subject'
    )
  end

  let(:camp) { create :camp }
  let(:position) { 2 }
  let(:dummy_class) { Class.new(SiegeMachine) }

  let(:existing_resource) do
    dummy_class.create camp: camp, position: position, damages: 1, name: 'Test'
  end

  it 'ignores himself' do
    subject.save
    expect(subject).to be_valid
  end

  it 'can have the same position as another siege machine of different type' do
    expect(existing_resource).to be_persisted
    expect(existing_resource.camp).to be subject.camp
    expect(subject).to be_valid
  end

  it 'cannot have the same position as another machine' do
    described_class.create camp: camp, position: position, damages: 1, name: 'Existing'

    expect(subject).to be_invalid
    expect(subject.errors.messages).to include(
      position: ["Another #{described_class.name} is already in position #{subject.position}"]
    )
  end
end
