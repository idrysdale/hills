require "json"

class HillStore
  def initialize(hills_file)
    @hills_file = hills_file
  end

  def get_all
    file = File.read(@hills_file)
    data = JSON.parse(file)
    data.map { |row|
      Hill.new(
        row['name'],
        row['absolute_height']
      )
    }
  end
end
