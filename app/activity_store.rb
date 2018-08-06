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
end
