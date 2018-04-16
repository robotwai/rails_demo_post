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

  def update_data
    p params
    respond_to do |format|
        if Person.update(params["id"], :phone=> params["phone"], :address=>params["address"] ,:name=>params["name"])
          format.json {render json: {'status'=>"0",'data'=> Person.find(request.query_parameters["id"])} }
        else
          #format.json {render json: json_str.to_json }#如果用json字符串，则需要通过to_json转化格式返回给前台js，那么前台需要执行eval来再次转换格式  
          format.json { render json: a.errors, status: :unprocessable_entity } #此处建议使用hash格式数据返回，这样前台js就无需执行eval来转换格式
        end  
    end  
  end
  def save_data  
      p params  
      a = Person.new
      a.phone = params["phone"]
      a.address = params["address"]
      a.name = params["name"]
      respond_to do |format|
          if a.save
            format.json {render json: {'status'=>"0",'data'=> Person.last} }
          else
            #format.json {render json: json_str.to_json }#如果用json字符串，则需要通过to_json转化格式返回给前台js，那么前台需要执行eval来再次转换格式  
            format.json { render json: a.errors, status: :unprocessable_entity } #此处建议使用hash格式数据返回，这样前台js就无需执行eval来转换格式
          end  
      end  
  end  

  def get_data  
      # @person = Person.find(params["id"])
      @people = Person.all
      respond_to do |format|
        format.html { render json: {'status'=>"0",'data'=>"ok"} }
        format.json { render json: @people  }
      end 
  end 

  def get_one_data  
      p request.query_parameters 
      @person = Person.find(request.query_parameters["id"])
      respond_to do |format|
        format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
        # format.json { render json: {'status'=>"0",'data'=>@person}  }
        format.json { render json: @person }
      end 
      
  end 

  def remove
    @person = Person.find(params["id"])
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { render json: {'status'=>"0",'data'=>"ok"}  }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:name, :address, :phone)
    end
end
