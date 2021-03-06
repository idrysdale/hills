require 'strava/api/v3'

class StravaActivityDownloader

  def initialize(client)
    @client = client
  end

  def download_activities(started_since:)
    data_of_new_activities(started_since)
  end

  def download_activity(strava_activity_id:)
    strava_activity = @client.retrieve_an_activity(strava_activity_id)
    create_activity_data_for(strava_activity)
  end

  private

  def unix_epoch_time(iso8601_time)
    iso8601_time.nil? ? nil : Time.parse(iso8601_time).to_i
  end

  def data_of_new_activities(started_since)
    concat_arrays(
      Enumerator.new { |yielder|
        loop do
          activities = download_new_activities(started_since)
          yielder.yield(activities)
          break if activities.empty?

          started_since = activities.last.started_at
        end
      }
    )
  end

  def concat_arrays(array_of_arrays)
    array_of_arrays.reduce(:+)
  end

  def download_new_activities(started_since)
    params = {
      'after' => unix_epoch_time(started_since),
      'per_page' => 100
    }
    @client.list_athlete_activities(params)
      .select { |strava_activity|
        course_data = download_course_data_for(strava_activity['id'])
        course_data != nil
      }
      .map { |strava_activity|
        # sleep(2)
        create_activity_data_for(strava_activity)
      }
    rescue SocketError
      puts "We got a Net::HTTP SocketError!"
      return []
  end

  def create_activity_data_for(strava_activity)
    course_data = download_course_data_for(strava_activity['id'])
    ActivityData.new(
      strava_activity['id'],
      strava_activity['name'].tr("'", ""),
      strava_activity['start_date'],
      course_data
    )
  end

  def download_course_data_for(activity_id)
    begin
      activity_stream = @client.retrieve_activity_streams(activity_id, 'latlng').first
      return activity_stream['data']
    rescue Strava::Api::V3::ClientError
      return nil
    end
  end
end
