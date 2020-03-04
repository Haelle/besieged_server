require 'rails_helper'

RSpec.describe OngoingTask, type: :model do
  it { is_expected.to have_db_column(:id).of_type(:uuid) }
  it { is_expected.to have_db_column(:type).of_type(:string) }
  it { is_expected.to have_db_column(:params).of_type(:json) }
  it { is_expected.to have_db_column(:action_points_spent).of_type(:integer).with_options(default: 0) }
  it { is_expected.to have_db_column(:action_points_required).of_type(:integer).with_options(default: 1) }
  it { is_expected.to have_db_column(:repeatable).of_type(:boolean).with_options(default: false) }
  it { is_expected.to have_db_column(:taskable_id).of_type(:uuid) }
  it { is_expected.to have_db_column(:taskable_type).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it { is_expected.to belong_to(:taskable) }

  describe '#building= alias' do
    let(:building) { create :building }

    it 'reads the building properly' do
      task = create :ongoing_task, taskable: building
      expect(task.building).to be building
    end

    it 'set the building properly' do
      task = build :ongoing_task
      task.building = building
      expect(task.building).to be building
      expect(task.taskable).to be building
    end
  end

  describe '#siege_machine= alias' do
    let(:siege_machine) { create :siege_machine }

    it 'reads the siege_machine properly' do
      task = create :ongoing_task, taskable: siege_machine
      expect(task.siege_machine).to be siege_machine
    end

    it 'set the siege_machine properly' do
      task = build :ongoing_task
      task.siege_machine = siege_machine
      expect(task.siege_machine).to be siege_machine
      expect(task.taskable).to be siege_machine
    end
  end

  describe '#valid?' do
    it 'must have a taskable' do
      task = build :ongoing_task, taskable: nil
      expect(task).to be_invalid
      expect(task.errors.messages).to include taskable: ['must exist']
    end

    it 'must have points spent' do
      task = build :ongoing_task, action_points_spent: nil
      expect(task).to be_invalid
      expect(task.errors.messages).to include action_points_spent: ['is not a number']
    end

    it 'must have points spent >= 0' do
      task = build :ongoing_task, action_points_spent: -1
      expect(task).to be_invalid
      expect(task.errors.messages).to include action_points_spent: ['must be greater than or equal to 0']
    end

    it 'must have points required' do
      task = build :ongoing_task, action_points_required: nil
      expect(task).to be_invalid
      expect(task.errors.messages).to include action_points_required: ['is not a number']
    end

    it 'must have points required > 0' do
      task = build :ongoing_task, action_points_required: 0
      expect(task).to be_invalid
      expect(task.errors.messages).to include action_points_required: ['must be greater than 0']
    end

    it 'cannot have spent more points than required' do
      task = build :ongoing_task, action_points_spent: 10, action_points_required: 5
      expect(task).to be_invalid
      expect(task.errors.messages).to include logic: ['cannot spend more action points than required']
    end

    it 'is valid' do
      expect(build(:ongoing_task)).to be_valid
    end
  end

  describe '#completed?' do
    it 'is not completed' do
      expect(create(:ongoing_task, :almost_completed)).not_to be_completed
    end

    it 'is completed' do
      expect(create(:ongoing_task, :completed)).to be_completed
    end
  end
end
