require 'factory_bot'
require 'faker'

dentist = FactoryBot.create(:user, id: 111)
FactoryBot.create(:user, token: '99vN03JCcaTDyQV-UgPjkw')

# 2021-01-04 appointments
FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 2)
FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 3)
FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 4)
FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 4), slot: 6)
# 2021-01-05 appointments
FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 1)
FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 11)
FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 12)
FactoryBot.create(:appointment, dentist: dentist, day: Date.new(2021, 1, 5), slot: 13)

# So for such a request http://localhost:3000/availabilities?dentist_id=111&from=2021-01-04&to=2021-01-06
# you should get such a response
#           # 2021-01-04
#           {"from"=>"2021-01-04T08:00:00", "to"=>"2021-01-04T08:30:00"}, 1 slot is available
#           {"from"=>"2021-01-04T10:00:00", "to"=>"2021-01-04T10:30:00"}, 5 slot is available
#           {"from"=>"2021-01-04T11:00:00", "to"=>"2021-01-04T12:00:00"}, 7-8 slots are available
#           {"from"=>"2021-01-04T13:00:00", "to"=>"2021-01-04T18:00:00"}, 11-18 slots are available
#           # 2021-01-05
#           {"from"=>"2021-01-05T08:30:00", "to"=>"2021-01-05T12:00:00"}, 2-8 slots are available
#           {"from"=>"2021-01-05T14:30:00", "to"=>"2021-01-05T18:00:00"}, 14-18 slots are available
#           # 2021-01-06
#           {"from"=>"2021-01-06T08:00:00", "to"=>"2021-01-06T12:00:00"}, 1-8 slots are available
#           {"from"=>"2021-01-06T13:00:00", "to"=>"2021-01-06T18:00:00"}, 11-18 slots are available