class Employee
  #this is a constant variable so you don't have to type it over and over in the hashes down there
  HEADERS = { #this part gives you access to the api via a secure token
                        "Accept" => "application/json"
                        "X-User-Email" => ENV['API_EMAIL'],
                         "Authorization" => "Token token=#{ ENV['API_KEY']}"
                        }

  attr_accessor :id, :first_name, :last_name, :email, :birthday

  def initialize(options_hash)
    @id = options_hash["id"]
    @first_name = options_hash["first_name"]
    @last_name = options_hash["last_name"]
    @email = options_hash["email"]
    @birthday = options_hash["birthday"] ? Date.parse(options_hash["birthday"]) : "N/A"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def friendly_birthday
    if birthday == "N/A"
      "N/A"
    else
      birthday.strftime('%b %d, %Y')
    end
  end

  #this method returns a single employee object, used to clean up the show method in controller
  def self.find(employee_id) #call the input this so you don't override the id variable
    Employee.new(Unirest.get("#{ ENV['HOST_NAME'] }/api/v2/employees/#{employee_id}.json",
                                              headers: HEADERS
                                                   ).body)
  end

  def self.all
    employee_collection = []
    response = Unirest.get(
                                        "#{ ENV['HOST_NAME'] }/api/v2/employees.json",
                                        headers: HEADERS
                                        ).body #this gives you an array of hashes, so you have to break it down into individual hashes to be able to create new employee objects

    response.each do |employee_hash|
      employees_collection << Employee.new(employee_hash)
    end

    return employee_collection
  end

  def destroy #don't need self here because it is an instance method, not a class method, you don't wanna destroy all emps, just 1. since it's an instance method we can call the id by using the attr_accessor or reader methods, so we can just type id in the Unirest line to find the specific employee 
    Unirest.delete("#{ ENV['HOST_NAME'] }/api/v2/employees/#{ id }", 
                            headers: HEADERS
                            )
  end

  def self.create(employee_params) #class method
     response = Unirest.post(
                             "#{ ENV['HOST_NAME'] }/api/v2/employees",
                             headers: HEADERS,
                             parameters: employee_params
                            ).body

     Employee.new(response)
  end

  def update(employee_params) #instance method. since it's an instance method we can call the id by using the attr_accessor or reader methods, so we can just type id in the Unirest line to find the specific employee

    response = Unirest.patch(
                              "#{ ENV['HOST_NAME'] }/api/v2/employees/#{ id }",
                              headers: HEADERS,
                              parameters: employee_params
                              ).body
    Employee.new(response)
  end

end