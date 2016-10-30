USER = 'daikin'
PASSWORD = 'pichonkun'
URL_BASE = "https://#{USER}:#{PASSWORD}@api-10.daikin.ishikari-dc.net"

class ZonesController < ApplicationController
  before_action :set_zone, only: [:show, :edit, :update, :destroy]

  def get_current
    machine_id = 4
    url = "#{URL_BASE}/equipments/#{machine_id}/"
    response = RestClient.get url
    return JSON.parse(response.body)
  end

  def get_comfortable_temperature(people, current_temperature)
    temperatures = people.map {|person| person.comfortable_temperature }
    average = people.blank? ? current_temperature : temperatures.inject(0.0){|r,i| r+=i }/temperatures.size
  end

  # GET /zones
  # GET /zones.json
  def index
    @zones = Zone.all
  end

  # GET /zones/1
  # GET /zones/1.json
  def show
    @people = Person.where(zone_id: @zone.id)
    @people = [] if @people.nil?
    current_machine = get_current
    current_temperature = current_machine['status']['room_temperature']
    @zone.current_temperature = current_temperature
    @zone.target_temperature = get_comfortable_temperature(@people, current_temperature)
  end

  # GET /zones/new
  def new
    @zone = Zone.new
  end

  # GET /zones/1/edit
  def edit
  end

  # POST /zones
  # POST /zones.json
  def create
    @zone = Zone.new(zone_params)

    respond_to do |format|
      if @zone.save
        format.html { redirect_to @zone, notice: 'Zone was successfully created.' }
        format.json { render :show, status: :created, location: @zone }
      else
        format.html { render :new }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /zones/1
  # PATCH/PUT /zones/1.json
  def update
    respond_to do |format|
      if @zone.update(zone_params)
        format.html { redirect_to @zone, notice: 'Zone was successfully updated.' }
        format.json { render :show, status: :ok, location: @zone }
      else
        format.html { render :edit }
        format.json { render json: @zone.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zones/1
  # DELETE /zones/1.json
  def destroy
    @zone.destroy
    respond_to do |format|
      format.html { redirect_to zones_url, notice: 'Zone was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_zone
      @zone = Zone.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def zone_params
      params.require(:zone).permit(:zone_name, :target_temperature, :current_temperature)
    end
end
