require 'sinatra'

get '/' do
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

  @student = names[rand(names.size)]
    erb :index
end
