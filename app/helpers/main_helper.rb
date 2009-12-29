module MainHelper
 
  #初始化城市列表
  def create_cities
    @cities = City.find(:all)
    @city_names = []
    @city_names[0]=["选择城市","选择城市"]
    i=1
    @cities.each do |f|
      @city_names.push([f.name,f.name])
      i=i+1
    end
    return @city_names
  end
  
  def initial_regions
    @regions_name = Array.new
    @regions_name.push("选择区域")
    return @regions_name
  end
  
  #初始化运动项目列表
  def create_sports
    @sports = SportType.find(:all)
    @sport_type_names = []
    @sport_type_names[0]=["运动项目","运动项目"]
    i=1
    @sports.each do |f|   
      @sport_type_names.push([f.sport_type,f.sport_type])
      i=i+1
    end
    return @sport_type_names
  end
end