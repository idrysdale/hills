class ExcursionStore
  def initialize(excursions_directory, activity_store)
    @excursions_directory = excursions_directory
    @activity_store = activity_store
  end

  def get(id)
    file = File.read("#{@excursions_directory}/#{id}.json")
    data = JSON.parse(file)
    Excursion.new(
      data['id'],
      data['name'],
      data['activities'].map { |activity_id|
        @activity_store.get(activity_id)
      }
    )
  end
end
