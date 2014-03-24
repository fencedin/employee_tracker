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
    puts "Press 'e' to view employee menu."
    puts "Press 'd' to view division menu."
    puts "Press 'x' to exit."

    case gets.chomp.downcase
    when 'e'
      clear
      employee_menu
    when 'd'
      clear
      division_menu
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

# ~~~~ EMPLOYEE ~~~~

def employee_menu
  puts "All current employees:\n\n"
  Employee.all.each do |emp|
    puts "\t\e[92m" + emp.name + " -- " + Division.where({id: emp.division_id})[0].name
  end
  puts "\n\e[32mPress 'a' to add an employee."
  puts "Press 'n' to update an employee name."
  puts "Press 'u' to update an employee division."
  puts "Press 'd' to delete an employee."
  puts "Press 'b' to go back to main menu"
  case gets.chomp.downcase
  when 'a'
    add_employee
  when 'n'
    update_employee_name
  when 'u'
    update_employee_id
  when 'b'
    clear
    main
  when 'd'
    delete_employee
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
  employee_menu
end

def update_employee_name
  puts "Which employee name do you want to edit?"
  current_employee = gets.chomp
  editting_employee = Employee.where({name: current_employee}).first
  puts "Enter the New Name:"
  edit_input = gets.chomp
  editting_employee.update({name: edit_input})
  clear
  puts "'#{current_employee}' has been updated to: '#{edit_input}'"
  employee_menu
end

def update_employee_id
  puts "Which employee division do you want to edit?"
  current_employee = gets.chomp
  editting_employee = Employee.where({name: current_employee}).first
  Division.all.each { |division| puts "\t\e[92m" + division.name }
  puts "\e[32mEnter the New Division:"
  division_input = gets.chomp

  id_to_update = Division.where({name: division_input})[0].id

  editting_employee.update({division_id: id_to_update})



  clear
  puts "'#{current_employee}' has been updated to: '#{division_input}'"
  employee_menu
end

def delete_employee
  puts "Which employee do you want to delete?"
  current_employee = gets.chomp
  editting_employee = Employee.where({name: current_employee}).first
  editting_employee.destroy
  clear
  puts "'#{current_employee}' was fired."
  employee_menu
end

# ~~~~ DIVISION ~~~~

def division_menu
  puts "Here is all the division the compmany:\n\n"
  Division.all.each { |division| puts "\t\e[92m" + division.name }
  puts "\n\e[32mPress 'a' to add a new division."
  puts "Press 'u' to update a division."
  puts "Press 'd' to delete a division."
  puts "Press 'b' to go back to main menu."
  case gets.chomp
  when 'a'
    add_division
  when 'u'
    update_division
  when 'd'
    delete_division
  when 'b'
    clear
    main
  else
    clear
    puts "not a valid option"
    division_menu
  end
end

def add_division
  puts "\nWhats the name of the new division?:"
  division_name = gets.chomp
  new_division = Division.create({name: division_name})
  clear
  puts "'#{division_name}' has been added.\n\n"
  division_menu
end

def update_division
  puts "\nWhich division do you want to edit?"
  current_division = gets.chomp
  editting_division = Division.where({name: current_division}).first
  puts "Enter the New Name:"
  edit_input = gets.chomp
  editting_division.update({name: edit_input})
  clear
  puts "'#{current_division}' has been updated to: '#{edit_input}'"
  division_menu
end

def delete_division
  puts "Which division do you want to delete?"
  current_division = gets.chomp
  editting_division = Division.where({name: current_division}).first
  editting_division.destroy
  clear
  puts "'#{current_division}' was fired."
  division_menu
end

# ~~~~OTHER METHODS~~~~

def clear
  system "clear && printf '\e[3J'"
end

clear
welcome
