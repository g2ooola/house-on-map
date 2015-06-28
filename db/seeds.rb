# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if MaterialType.count == 0
  MaterialType.create([{category: '鋼筋混凝土'}, {category: '磚造'}])
end

if BuildingFormatType.count == 0
  BuildingFormatType.create([{category: '透天'}, {category: '公寓'}, {category: '電梯大樓'}, {category: '套房'}])
end