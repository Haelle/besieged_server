require 'rails_helper'

RSpec.describe Assault::Taggable do
  subject do
    Class.new do
      include ActiveModel::Model
      include Assault::Taggable
    end
  end

  let(:tags) { described_class::TAGS }

  it 'mimic question mark methods' do
    tags.each do |tag|
      object = subject.new tags: [tag]
      # expect to be_citizen
      expect(object).to send("be_#{tag}")
    end
  end

  it 'respond false if not in tags' do
    tags.each do |tag|
      object = subject.new tags: [:not_a_tag]
      # expect not to be_citizen
      expect(object).not_to send("be_#{tag}")
    end
  end

  describe 'keeps basic method missing' do
    it 'ignores non-question mark methods' do
      object = subject.new
      expect { object.not_a_method }.to raise_error NoMethodError
    end

    it 'ignores non tags methods' do
      object = subject.new
      expect { object.taggable? }.to raise_error NoMethodError
    end
  end
end
