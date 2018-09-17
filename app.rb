require 'sinatra' # web server
require 'json' # allows json parsing
require 'pry' # debugging

# import students from external data file
require_relative 'data/class_students.rb'

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

# fist to five data.  It's a hash because each class will have its own key/value pair
fist_to_five_arrays = {}

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
    @names = DATA::UNH
  elsif requested_class == 'unh1'
    @names = DATA::UNH1
  elsif requested_class == 'unh2'
    @names = DATA::UNH2
  elsif requested_class == 'unh3'
    @names = DATA::UNH3
  elsif requested_class == 'unh4'
    @names = DATA::UNH4
  else
    @names = ''
  end

  return { :students => @names }.to_json
end

get '/api/v1/fisttofive/:class_program' do
  content_type :json

  class_program = params[:class_program]

  if !fist_to_five_arrays[class_program]
    fist_to_five_arrays[class_program] = [0,0,0,0,0, nil]
  end

  return {:results => fist_to_five_arrays[class_program]}.to_json
end

post '/api/v1/fisttofive' do
  # this post route handles post, put, and delete route actions to allow for consistent fetch calls in React components
  content_type :json

  # payload variable is declared b/c the request.body.read method can only be called once.
  payload = JSON.parse(request.body.read)

  # these variables improve readability.
  action = payload["action"]
  number = payload["number"]
  class_program = payload["classProgram"]

  # creates the data array if it doesn't exist.
  if !fist_to_five_arrays[class_program]
    fist_to_five_arrays[class_program] = [0,0,0,0,0, nil]
  end

  if action == 'reset'
    fist_to_five_arrays[class_program] = [0,0,0,0,0, true]

  elsif action == 'change'
    index = number.to_i - 1

    fist_to_five_arrays[class_program][index] -= 1
    fist_to_five_arrays[class_program][-1] = false
  elsif action == 'add'
    index = number.to_i - 1

    fist_to_five_arrays[class_program][index] += 1
    fist_to_five_arrays[class_program][-1] = false
  end

  return {:results => fist_to_five_arrays[class_program]}.to_json
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
