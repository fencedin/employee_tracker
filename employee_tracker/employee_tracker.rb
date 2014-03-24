require 'active_record'

require './lib/employee.rb'
require './lib/division.rb'
require 'pry'

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def welcome
  puts "\e[32mWelcome to the employee tracker!"
  main
end

def main
  choice = nil
  until choice == 'x'
    puts "Press 'e' to view employee menu"
    puts "Press 'd' to view/edit divisions."
    puts "Press 'x' to exit."

    case gets.chomp.downcase
    when 'e'
      clear
      employee_menu
    when 'd'
      clear
      list_divisions
    when 'x'
      clear
      puts "\nCiao!~\e[0m\n\n"
      exit
    else
      puts "Not a valid option"
      main
    end
  end
end

def employee_menu
  puts "All current employees:\n\n"
  Employee.all.each do |emp|
    puts "\t\e[92m" + emp.name + " -- " + Division.where({id: emp.division_id})[0].name
  end
  puts "\n\e[32mPress 'a' to add an employee."
  puts "Press 'u' to update an employee."
  puts "Press 'd' to delete an employee."
  puts "Press 'b' to go back to main menu"
  case gets.chomp.downcase
  when 'a'
    add_employee
  when 'l'
    clear
    list_employees
  when 'u'
    clear
    update_employee
  when 'b'
    clear
    main
  when 'd'
    clear
    delete_employee
  when 'x'
    clear
    puts "\nCiao!~\e[0m\n\n"
    exit
  else
    puts "Not a valid option"
    main
  end
end


def add_employee
  puts "\nWhats the name of the employee?:"
  employee_name = gets.chomp
  puts "\nWhat division are they in?:"
  Division.all.each { |division| puts "\t\e[92m" + division.name }
  division_name = gets.chomp

  selected_division = Division.where({name: division_name}).first

  new_employee = selected_division.employees.create({name: employee_name})

  clear
  puts "\e[32m'#{employee_name}' is now being tracked by the '#{division_name}'.\n\n"
end

def list_employees
  puts "Here is a list of all employees being tracked:\n\n"
  Employee.all.each { |employee| puts "\t\e[92m" + employee.name }
  puts "\n\e[32m"
end



def list_divisions
  puts "Here is all the division the compmany:\n\n"
  Division.all.each { |division| puts "\t\e[92m" + division.name }
  puts "\n\e[32mPress 'a' to add a new division."
  puts "Press 'b' to go back to main menu."
  case gets.chomp
  when 'a'
    add_division
  when 'b'
    clear
    main
  else
    clear
    puts "not a valid option"
    list_divisions
  end
end

def add_division
  puts "\nWhats the name of the new division?:"
  division_name = gets.chomp
  new_division = Division.create({name: division_name})
  clear
  puts "'#{division_name}' has been added.\n\n"
  list_divisions
end

def clear
  system "clear && printf '\e[3J'"
end

clear
welcome
