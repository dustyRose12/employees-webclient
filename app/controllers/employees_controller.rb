class EmployeesController < ApplicationController

  def index
    @employees = Employee.all
  end

  def new
    
  end

  def create
    @employee = Employee.create( 
                                          first_name: params[:first_name],
                                          last_name: params[:last_name],
                                          email: params[:email]
                                          )

    redirect_to "/employees/#{@employee.id}"
  end

  def show
    @employee = Employee.find(params[:id])
    # @employee = Employee.new(Unirest.get("#{ ENV['HOST_NAME'] }/api/v2/employees/#{params[:id]}.json").body) #this line is replaced by creating the find method in the model.
  end

  def edit
    @employee = Employee.find(params[:id])
    # @employee = Unirest.get("#{ ENV['HOST_NAME'] }/api/v2/employees/#{params[:id]}.json").body

  end

  def update
    @employee = Employee.find(params[:id])
    @employee.update( 
                                    first_name: params[:first_name],
                                    last_name: params[:last_name],
                                    email: params[:email]
                                    )
    redirect_to "/employees/#{@employee.id}"
  end

  def destroy

    @employee = Employee.find(params[:id])
    @employee.destroy
     redirect_to '/'
  end
  
end










