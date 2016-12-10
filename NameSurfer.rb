require 'sinatra'
require 'sinatra/reloader'
require 'dm-core'
require 'dm-migrations'
require 'dm-sqlite-adapter'
require 'json'

configure do
  set :nameData, Array.new
end

get '/'  do
  settings.nameData = Array.new
  erb	:home
end

configure do 
	DataMapper.setup(:default,"sqlite://#{Dir.pwd}/Names.db")
end

#Creates the class for holding the name data from 1900-2000
class Name
	include DataMapper::Resource
	property :ID, Serial
	property :Name, String
	property :year1900, Integer
	property :year1910, Integer
	property :year1920, Integer
	property :year1930, Integer
	property :year1940, Integer
	property :year1950, Integer
	property :year1960, Integer
	property :year1970, Integer
	property :year1980, Integer
	property :year1990, Integer
	property :year2000, Integer

end

#Checks if the name exists in the database
def foundName?(inputName)
  @names.each do |entry|
    if inputName == entry.Name
      data = Array.new
      data.push(@name)
      data.push(entry.year1900)
      data.push(entry.year1910)
      data.push(entry.year1920)
      data.push(entry.year1930)
      data.push(entry.year1940)
      data.push(entry.year1950)
      data.push(entry.year1960)
      data.push(entry.year1970)
      data.push(entry.year1980)
      data.push(entry.year1990)
      data.push(entry.year2000)
      settings.nameData.push(data)
      return true
    end
  end
  false
end

DataMapper.finalize()


#Using JSON sends the array of name information if the name is found
get '/NameSurfer' do
	@names = Name.all
	if params['name']
    content_type :json
		@name = params['name']
    
    #Names should only contain alphabetical letters
		@name = @name.gsub(/[^A-Za-z\-\/']/,'')

    if foundName?(@name.downcase) then
      @info = "Name Entered: #{@name}"
      { :result => settings.nameData}.to_json
    else
      erb	:graph
    end
  else
    halt(404)
	end
end

get '/NameSurf' do
  erb	:graph
end



