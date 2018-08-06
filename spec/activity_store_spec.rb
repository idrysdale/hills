require "activity_store"

RSpec.describe ActivityStore do
  let(:temporary_storage_directory) { 'tmp/activities' }
  subject(:activity_store) {
    ActivityStore.new(
      temporary_storage_directory
    )
  }

  before do
    FileUtils.rm_rf("#{temporary_storage_directory}/.")
  end

  describe '#push' do
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
        files = Dir["#{temporary_storage_directory}/*"]
        expect(files.count).to eq(1)
      end

      it 'names the json file after the activity id' do
        file = Dir["#{temporary_storage_directory}/*"].first
        expect(File.basename(file)).to eq("#{new_activity_data.id}.json")
      end

      it 'writes the correct data' do
        activity_file = Dir["#{temporary_storage_directory}/*"].first
        activity_data_dump = File.read(activity_file)
        activity_data_hash = JSON.parse(activity_data_dump)

        expect(activity_data_hash['id']).to eq(new_activity_data.id)
        expect(activity_data_hash['name']).to eq(new_activity_data.name)
      end
    end
  end

  after do
    FileUtils.rm_rf("#{temporary_storage_directory}")
  end
end
