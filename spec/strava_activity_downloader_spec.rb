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
end
