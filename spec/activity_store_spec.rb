require "activity"
require "activity_store"
require "course"
require "json"

RSpec.describe ActivityStore do
  describe '#push' do
    let(:storage_directory) {
      'spec/support/activities/tmp'
    }
    subject(:activity_store) {
      ActivityStore.new(
        storage_directory
      )
    }

    before do
      FileUtils.rm_rf("#{storage_directory}/.")
    end

    context 'with new activity data' do
      let(:new_activity_data) {
        ActivityData.new(
          1,
          "A walk up t' hill",
          Time.now,
          [[1.1234,1.1234], [1.434,2.434]]
        )
      }

      before do
        activity_store.push(new_activity_data)
      end

      it 'writes a file to disk' do
        files = Dir["#{storage_directory}/*"]
        expect(files.count).to eq(1)
      end

      it 'names the json file after the activity id' do
        file = Dir["#{storage_directory}/*"].first
        expect(File.basename(file)).to eq("#{new_activity_data.id}.json")
      end

      it 'writes the correct data' do
        activity_file = Dir["#{storage_directory}/*"].first
        activity_data_dump = File.read(activity_file)
        activity_data_hash = JSON.parse(activity_data_dump)

        expect(activity_data_hash['id']).to eq(new_activity_data.id)
        expect(activity_data_hash['name']).to eq(new_activity_data.name)
      end
    end

    after do
      FileUtils.rm_rf("#{storage_directory}")
    end
  end
end
