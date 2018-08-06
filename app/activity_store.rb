class ActivityStore
  def initialize(directory = 'data/activities')
    @directory = directory
    FileUtils.mkdir_p "#{@directory}/"
  end

  def push(activity_data)
    file_name = "#{@directory}/#{activity_data.id}.json"
    File.open(file_name, "w") do |f|
      f.write(activity_data.to_json)
    end
  end

  def get(id)
    file = File.read("#{@directory}/#{id}.json")
    data = JSON.parse(file)
    Activity.new(
      data['id'].to_i,
      data['name'],
      data['started_at'],
      Course.new(data['course'])
    )
  end
end
