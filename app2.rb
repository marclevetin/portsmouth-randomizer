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
  # erb :index
  erb :home
end

post '/api/v1/students' do
  content_type :json

  requested_class = request.body.read

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


# Sinatra/ERB routes
get '/:class_program' do
  # determine which class we're working with
  class_program = params['class_program']
  students = select_names(class_program, picked, absent)

  # pick a random student and image
  @student = @names[rand(@names.size)]
  @image = photos[rand(photos.size)]

  # absent students
  @absent = absent

  # process the student and reset the picked list if needed
  process_student(@student, students, picked)


  erb :class
end

post '/:class_program' do
  class_program = params[:class_program]
  groups = params[:groups]

  redirect to("#{class_program}/groups/#{groups}")
end

get '/:class_program/groups/:count' do
  class_program = params[:class_program]
  count = params[:count].to_i

  @absent = absent
  # it's possible that @names doesn't represent all the students in the class b/c
  # some have answered questions.  all_names ensures that the entire class is
  # included in a group.
  all_names = select_names(class_program, [], absent)

  @groups = all_names.shuffle.each_slice(count).to_a
  if @groups.last.size != count
    i = 0
    @groups.last.each do |person|
      @groups[i].push(person)
      if i < @groups.size - 1
        i = i + 1
      else
        i = 0
      end
    end
    @groups.pop
  end

  # Appends "leader designation"
  @groups.each do |group|
    group[0] = group[0] + " (lead)"
  end

  @groups

  erb :groups
end

get '/:class_program/absent' do
  class_program = params[:class_program]

  # passing in an empty array for picked students because we need everyone in the class
  @full_class = select_names(class_program, [])
  @absent = absent

  erb :absent
end

post '/:class_program/absent' do
  class_program = params[:class_program]

  # other functions require 'absent' to be an array.  This conditional ensures that happens.
  if params[:people]
    absent = params[:people]
  else
    absent = []
  end

  redirect to("#{class_program}")
end

get '/:class_program/fisttofive' do
  class_program = params[:class_program]

  @results = fist_to_five_array

  erb :fisttofive
end


post '/:class_program/fisttofive' do
  class_program = params[:class_program]

  if params[:reset]
    fist_to_five_array = [0,0,0,0,0]
  else
    student_feeling = params[:feeling].to_i
    index = student_feeling - 1

    fist_to_five_array[index] += 1
  end

  redirect to("#{class_program}/fisttofive")
end

private

def process_student(student, class_program, picked)
  if class_program.size > 0
    # remove them from the names array, so they won't be picked twice
    class_program.delete(student)
    picked.push(student)
  end

  if class_program.size == 0
    # when names is empty, all the students must have been picked.
    # this restores names to its original state.
    class_program = picked
  end
end

def select_names(class_program, picked, absent = nil)
  if class_program == 'unh'
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
  elsif class_program == 'unh1'
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
  end

  # removes absent folks from the list.
  @names = @names - absent.to_a
  # removes picked people from the list.
  @names = @names - picked

  # resets names when everyone has been picked.  (Common in small classes)
  if @names.size == 0
    @names = select_names(class_program, [], absent.to_a)
  end

  return @names
end
