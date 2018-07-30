require "hill"
require "hill_store"
require "pry"

RSpec.describe HillStore do
  subject(:hill_store) {
    HillStore.new(
      "spec/support/two_hills.json"
    )
  }

  describe 'getting hills' do
    before do
      @results = hill_store.get_all
    end

    it 'retrieves the right number of hills from the file' do
      expect(@results.count).to be 2
    end

    it 'returns an array of Hills' do
      expect(@results.first).to be_a(Hill)
    end
  end
end
