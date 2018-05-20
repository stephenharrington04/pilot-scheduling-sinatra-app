require './config/environment'

use Rack::MethodOverride
use InstructorController
use StudentController
use FlightController
run ApplicationController
