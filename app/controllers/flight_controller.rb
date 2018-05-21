class FlightController < ApplicationController

  get '/flights' do
    @flights = Flight.all
    erb :'/flights/index'
  end

  get '/flights/new' do
    erb :'flights/new'
  end

  post '/flights' do
    flight = Flight.create(params[:flight])
    redirect "/flights/#{flight.id}"
  end

  get '/flights/:id' do
    @flight = Flight.find(params[:id])
    erb :'/flights/show'
  end

end
