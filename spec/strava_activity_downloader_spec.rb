require 'activity_data'
require 'strava_activity_downloader'
require 'support/strava_api_v3_client_double'

RSpec.describe StravaActivityDownloader do
  let(:client) { StravaApiV3ClientDouble.new }

  subject(:strava_activity_downloader) {
    StravaActivityDownloader.new(client)
  }

  describe '#download_activities(started_since:)' do
    context 'with activities with an empty course to download' do
      before do
        @activity_data = strava_activity_downloader
          .download_activities(started_since: '2016-10-07T05:00:00Z')
        # 1475816400
      end

      it 'gets the data and pushes to the store' do
        expect(@activity_data.count).to eq 4
      end
    end

    context 'with four activities and courses to download' do
      before do
        @activity_data = strava_activity_downloader
          .download_activities(started_since: '2016-10-08T05:00:00Z')
        # 1475902800
      end

      it 'gets the activity data for the four activities' do
        expect(@activity_data.count).to eq 4
      end
    end
  end

  describe '#download_activity(strava_activity_id:)' do
    context 'with a valid strava_id' do
      before do
        @activity_data = strava_activity_downloader
          .download_activity(strava_activity_id: '1')
      end

      it 'gets the activity and course data' do
        expect(@activity_data.id).to eq 1
      end

      it 'gets the associated course' do
        expect(@activity_data.course_data).to be_an(Array)
        expect(@activity_data.course_data.first).to eq([53.364948, -1.502514])
      end
    end
  end
end
