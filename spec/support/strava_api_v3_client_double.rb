class StravaApiV3ClientDouble
  def list_athlete_activities(params)
    case params['after']
    when 1475816400 # October 7, 2016 5:00:00 AM
      file_name = "five_acitivities_with_one_empty_course"
    when 1475902800 # Saturday, October 8, 2016 5:00:00 AM
      file_name = "four_complete_activities_with_courses"
    else
      file_name = "no_new_activities"
    end
    file = File.read(
      "spec/support/strava_activity_streams/#{file_name}.json"
    )
    data = JSON.parse(file)
  end

  def retrieve_activity_streams(activity_id, type)
    file = File.read(
      "spec/support/strava_activity_streams/course_streams/#{activity_id}_latlng.json"
    )
    data = JSON.parse(file)
  end

  def retrieve_an_activity(activity_id)
    file = File.read(
      "spec/support/strava_activity_streams/activities/strava_id_#{activity_id}.json"
    )
    data = JSON.parse(file)
  end

end
