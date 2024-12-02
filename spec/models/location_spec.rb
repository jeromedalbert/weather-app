require 'rails_helper'

describe Location do
  it { should validate_presence_of :zip_code }
  it { should validate_presence_of :country_code }

  describe '.build_from_id' do
    context 'when id is present' do
      subject(:location) { Location.build_from_id('92120-US') }

      it { expect(location.zip_code).to eq '92120' }
      it { expect(location.country_code).to eq 'US' }
    end

    context 'when id is nil' do
      subject(:location) { Location.build_from_id(nil) }

      it { expect(location.zip_code).to eq nil }
      it { expect(location.country_code).to eq nil }
    end
  end

  describe '#id' do
    subject(:location) { Location.new(zip_code: '92120', country_code: 'US') }

    it { expect(location.id).to eq '92120-US' }
  end

  describe '#persisted?' do
    it { expect(Location.new).not_to be_persisted }
    it { expect(Location.new(zip_code: '92120', country_code: 'US')).to be_persisted }
  end
end
