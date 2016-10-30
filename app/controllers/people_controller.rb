class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  # GET /people
  # GET /people.json
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  def get_current
    machine_id = 4
    url = "https://#{Settings.machine.user}:#{Settings.machine.password}@#{Settings.machine.url_base}/equipments/#{machine_id}/"
    response = RestClient.get url
    puts url
    return JSON.parse(response.body)
  end

  def get_comfortable_temperature(people, current_temperature)
    temperatures = people.map {|person| person.comfortable_temperature }
    average = people.blank? ? current_temperature : temperatures.inject(0.0){|r,i| r+=i }/temperatures.size
    average = current_temperature if average.nil?
    average = 15 if average < 15
    average = 35 if average > 35
    average = average.to_i
  end

  def set_target_temperature(target_temperature)
    machine_id = 4
    params = {"id": machine_id,
      "status": {
        "power": 1,
        "operation_mode": 4,
        "set_temperature": target_temperature,
        "fan_speed": 3,
        "fan_direction": 7
      }
    }
    url = "https://#{user}:#{password}@api-10.daikin.ishikari-dc.net/equipments/#{machine_id}/"
    response = RestClient.post url, params.to_json, {content_type: :json, accept: :json}
    return JSON.parse(response.body)
  end

  def enter
    args = JSON.parse(request.body.read)
    zone_id = args['zone_id']
    @person = Person.find(params[:id])
    @person.zone_id = zone_id
    @person.save

    # response zone he entered
    @zone = Zone.find(zone_id)
    @people = Person.where(zone_id: @zone.id)

    current_machine = get_current
    current_temperature = current_machine['status']['room_temperature']
    @zone.target_temperature = get_comfortable_temperature(@people, current_temperature)
    @zone.save

    render 'zones/show'
  end
  def exit
    @person = Person.find(params[:id])
    zone_id_left = @person.zone_id

    @person.zone_id = nil
    @person.save

    # error handling

    # response zone he left
    begin
      @zone = Zone.find(zone_id_left)
    rescue
      render json: {}, status: '404'
      return
    end
    @people = Person.where(zone_id: @zone.id)

    current_machine = get_current
    current_temperature = current_machine['status']['room_temperature']
    @zone.target_temperature = get_comfortable_temperature(@people, current_temperature)
    @zone.save

    render 'zones/show'
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:name, :image_name, :gender, :temperature_preference, :comfortable_temperature, :comfortable_humidity)
    end
end
