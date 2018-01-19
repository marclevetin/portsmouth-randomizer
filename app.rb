require 'sinatra'
require 'json'
require 'pry'

set :bind, "0.0.0.0"
set :public_folder, File.join(File.dirname(__FILE__), "public")

photos = [
  'http://cdn.portsmouthnh.com/wp-content/uploads/2017/10/north-church-820x820.jpg',
  'http://cdn.portsmouthnh.com/wp-content/uploads/2017/10/newcastle-027-5-820x547.jpg',
  'http://cdn.portsmouthnh.com/wp-content/uploads/2016/01/2015Fireworks1-820x615.jpg',
  'http://cdn.portsmouthnh.com/wp-content/uploads/2015/01/SteveMazzarella_summer2013_1.jpg'
]
# students that have been "picked" and answered a question already
picked = []

# students that have been marked "absent"
absent = []

fist_to_five_array = [0,0,0,0,0]

# react routes
get '/' do
  erb :index
end

get '/:class_program' do
  erb :home
end

get '/api/v1/students/:class_program' do
  content_type :json

  requested_class = params['class_program']

  if requested_class == 'unh'
    @names = [
      'Adam M',
      'Ben B',
      'Chase L',
      'Connor M',
      'Doreen W',
      'Elizah H',
      'Emma P',
      'Helen P',
      'Jacob L',
      'James M',
      'James R',
      'Janet C',
      'Joseph C',
      'Justin R',
      'Karen J',
      'Katie D',
      'Lauren M',
      'Lauren W',
      'Louise H',
      'Michael F',
      'Michelle B',
      'Mike S',
      'Paul H',
      'Thomas P',
      'Victoria G'
    ]
  elsif requested_class == 'unh1'
    @names = [
      'Donald B',
      'Alexander	J',
      'Eric S',
      'Matthew	M',
      'Samuel L',
      'Kevin S',
      'Thomas H',
      'Mary D',
      'Roxana M',
      'John R',
      'Sarah S',
      'Eric M',
      'Askar T',
      'Clark M',
      'Anitharaj S',
      'JoAnn E',
      'Aaron B',
      'Shraddha B',
      'Rupali M',
      'Keira N',
      'Anthony K',
      'Jake O',
      'Rebecca B',
      'Noah S',
      'Joy C'
    ]
  else
    @names = ''
  end

  return { :students => @names }.to_json
end

get '/api/v1/fisttofive' do
  content_type :json
  return {:results => fist_to_five_array}.to_json
end

post '/api/v1/fisttofive' do
  # this post route handles post, put, and delete route actions to allow for consistent fetch calls in React components
  content_type :json

  # payload variable is declared b/c the request.body.read method can only be called once.
  payload = JSON.parse(request.body.read)

  # these variables improve readability.
  action = payload["action"]
  number = payload["number"]

  if action == 'reset'
    fist_to_five_array = [0,0,0,0,0]

  elsif action == 'change'
    index = number.to_i - 1

    fist_to_five_array[index] -= 1
  elsif action == 'add'
    index = number.to_i - 1

    fist_to_five_array[index] += 1
  end

  return {:results => fist_to_five_array}.to_json
end

post '/api/v1/absent' do
  content_type :json

  payload = JSON.parse(request.body.read)

  if payload["reset"]
    absent = []
  elsif payload["checked"]
    absent.push(payload["currentStudent"])
  else
    absent.delete(payload["currentStudent"])
  end

  return {:absent => absent}.to_json
end



# content_type :json
#
# requested_class = params['class_program']
#
# if requested_class == 'unh'
#   @names = [
#     'Adam M',
#     'Ben B',
#     'Chase L',
#     'Connor M',
#     'Doreen W',
#     'Elizah H',
#     'Emma P',
#     'Helen P',
#     'Jacob L',
#     'James M',
#     'James R',
#     'Janet C',
#     'Joseph C',
#     'Justin R',
#     'Karen J',
#     'Katie D',
#     'Lauren M',
#     'Lauren W',
#     'Louise H',
#     'Michael F',
#     'Michelle B',
#     'Mike S',
#     'Paul H',
#     'Thomas P',
#     'Victoria G'
#   ]
# elsif requested_class == 'unh1'
#   @names = [
#     'Donald B',
#     'Alexander	J',
#     'Eric S',
#     'Matthew	M',
#     'Samuel L',
#     'Kevin S',
#     'Thomas H',
#     'Mary D',
#     'Roxana M',
#     'John R',
#     'Sarah S',
#     'Eric M',
#     'Askar T',
#     'Clark M',
#     'Anitharaj S',
#     'JoAnn E',
#     'Aaron B',
#     'Shraddha B',
#     'Rupali M',
#     'Keira N',
#     'Anthony K',
#     'Jake O',
#     'Rebecca B',
#     'Noah S',
#     'Joy C'
#   ]
# else
#   @names = ''
# end
#
# return { :students => @names }.to_json
