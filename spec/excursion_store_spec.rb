require "JSON"
require "activity"
require "activity_store"
require "course"
require "excursion"
require "excursion_store"
require "pry"

RSpec.describe ExcursionStore do
  
  let(:activity_store) {
    ActivityStore.new('spec/support/activities')
  }

  subject(:excursion_store) {
    ExcursionStore.new(
      'spec/support/excursions',
      activity_store
    )
  }

  describe '#get' do
    context 'an excursion with two activities' do
      
      before do
        @excursion = excursion_store.get(1)
      end

      it 'retrieves a single excursion' do
        expect(@excursion).to be_an(Excursion)
      end

      it 'retrieves the right number of activities for the excursion' do
        expect(@excursion.activities.count).to be 2
      end

    end
  end
end
