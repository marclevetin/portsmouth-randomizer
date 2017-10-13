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

get '/' do
  @student = names[rand(names.size)]
    erb :index
end

post '/' do
  groups = params[:groups]
  redirect to("/groups/#{groups}")
end

get '/groups/:count' do
  count = params[:count].to_i
  @groups = names.shuffle.each_slice(count).to_a
  if @groups[-1] != count && @groups.size % count != 0
    last_group = @groups[-1]
    i = 0
    last_group.each do |person|
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
    group[0] = group[0] + " (leader)"
  end

  @groups

  erb :groups
end
