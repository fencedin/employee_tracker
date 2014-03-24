require 'active_record'

require './lib/employee.rb'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "Welcome to the employee tracker!"
  main
end

def main
  choice = nil
  until choice == 'x'
    puts "Press 'a' to add an employee."
    puts "Press 'l' to list all employees."
    puts "Press 'x' to exit."

    case gets.chomp.downcase
    when 'a'
      add_employee
    when 'l'
      list_employees
    when 'x'
      puts "Ciao!~"
      exit
    else
      puts "Not a valid option"
      main
    end
  end
end

def add_employee
  puts "Whats the name of the employee?:"
  employee_name = gets.chomp
  new_employee = Employee.create({name: employee_name})
  puts "'#{employee_name}' is now being tracked."
end

def list_employees
  puts "Here is a list of all employees being tracked:"
  Employee.all.each { |employee| puts employee.name }
end


welcome
