require 'sinatra'
require 'pry'
require 'net/http'

# these access the keys in the .env file.  Keep it secret.  Keep it safe.
require 'dotenv'
Dotenv.load

photos = [
  'http://cdn.portsmouthnh.com/wp-content/uploads/2017/10/north-church-820x820.jpg',
  'http://cdn.portsmouthnh.com/wp-content/uploads/2017/10/newcastle-027-5-820x547.jpg',
  'http://cdn.portsmouthnh.com/wp-content/uploads/2016/01/2015Fireworks1-820x615.jpg',
  'http://cdn.portsmouthnh.com/wp-content/uploads/2015/01/SteveMazzarella_summer2013_1.jpg'
]

picked = []

get '/:class_program' do
  # determine which class we're working with
  class_program = params['class_program']
  select_names(class_program)

  # pick a random student and image
  @student = @names[rand(@names.size)]
  @image = photos[rand(photos.size)]

  # process the student and reset the picked list if needed
  process_student(@student, class_program, picked)

  erb :index
end

post '/' do
  groups = params[:groups]
  redirect to("/groups/#{groups}")
end

get '/groups/:count' do
  count = params[:count].to_i
  # it's possible that names doesn't represent all the students in the class b/c
  # some have answered questions.  all_names ensures that the entire class is
  # included in a group.
  all_names = names + picked

  @groups = all_names.shuffle.each_slice(count).to_a
  if @groups.last.size != count
    i = 0
    @groups.last.each do |person|
      # bug whereby the i is too large.  Need to change the iterator to
      # loop through from 0 to @groups.size -1
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

def select_names(class_program)
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

  return @names
end
