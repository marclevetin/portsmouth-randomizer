require 'sinatra'
require 'pry'

names = [
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

picked = []

get '/' do
  # pick a random student
  @student = names[rand(names.size)]

  if names.size > 0
    # remove them from the names array, so they won't be picked twice
    names.delete(@student)
    picked.push(@student)
  elsif names.size == 0
    # when names is empty, all the students must have been picked.
    # this restores names to its original state.
    names = picked
  end

  @student

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
