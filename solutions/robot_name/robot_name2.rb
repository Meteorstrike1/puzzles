# Similar to previous attempt but using a simplified regex with less combinations to demonstrate an approach that avoids
# retrying indefinitely and flags if the maximum number of available names have been reached

require 'faker'

class Robot
  # Constants
  DEFAULT_NAME = 'unnamed'.freeze
  NUM_ATTEMPTS = 5
  NAME_REGEX = /[0-9][A-B]/
  TOTAL_UNIQUE_NAMES = 20

  # Class instance variables
  @current_names = Set.new
  @out_of_names = false

  class << self
    attr_reader :current_names, :out_of_names
  end

  # Instance variable, initialise as a placeholder rather than nil
  attr_reader :name

  def initialize
    @name = default_name
  end

  # Errors
  class DuplicateName < StandardError; end
  class NamingFailedError < StandardError; end
  class OutOfNamesError < StandardError; end

  # First time boot up and add to list, give up if max set_name attempts, raise error if no names left
  def boot_up
    if @name == DEFAULT_NAME
      raise OutOfNamesError if self.class.out_of_names

      begin
        @name = set_name
        add_entity
        'Booting up robot...'
      rescue NamingFailedError
        # Call method to check if we have reached the maximum number of names available
        self.class.out_of_names?
        puts 'Naming failed, max attempts succeeded'
      end
    else
      'Beep boop, I am already booted up'
    end
  end

  # Remove from list and reset name to placeholder
  def reset_factory_settings
    return 'Cannot reset before first boot up' if @name == DEFAULT_NAME

    remove_entity
    default_name
    'Resetting to factory settings'
  end

  # Ask robot their name, if never booted up then boot them up first
  def ask_name
    puts boot_up if @name == DEFAULT_NAME
    "Hello my name is #{@name}"
  end

  # Class method to return the in use names, or can call Robot.current_names
  def self.named_robots
    "List of currently named robots: #{@current_names}"
  end

  # Class method to check if any names remain
  def self.out_of_names?
    @out_of_names = @current_names.length >= TOTAL_UNIQUE_NAMES
  end

  private

  def default_name
    @name = DEFAULT_NAME
  end

  # Generating the unique name, if attempts exceed max it raises an error
  def set_name(attempts = 0)
    name = Faker::Base.regexify(NAME_REGEX) # Reduced naming options
    raise DuplicateName if self.class.current_names.include?(name)

    @name = name
  rescue DuplicateName
    raise NamingFailedError if attempts >= NUM_ATTEMPTS

    attempts += 1
    puts "Attempt number #{attempts}"
    set_name(attempts)
  end

  def add_entity
    self.class.current_names << @name
  end

  def remove_entity
    self.class.current_names.delete(@name)
    self.class.out_of_names?
  end
end

# Make a list of robots
list = []
50.times { list << Robot.new }
total_tried = 0

# Attempt to name the robots, exit when maximum available names have been reached
list.each do |robot|
  robot.boot_up
  total_tried += 1
rescue Robot::OutOfNamesError
  puts 'Exiting loop - run out of names'
  total_tried += 1
  break
else
  puts robot.name
end

total_named = Robot.current_names.length
total_unnamed = total_tried - total_named

puts "Number of boot ups attempted: #{total_tried}\nNumber of successful boot ups: #{total_named}\nNumber of failed boot ups: #{total_unnamed}"
puts Robot.named_robots

# Factory reset will clear out of names back to false
puts "Are robots out of names?: #{Robot.out_of_names?}"
puts "Reset one of the robots - #{list[0].reset_factory_settings}"
puts "Are robots out of names?: #{Robot.out_of_names?}"
puts "Total number of named robots: #{Robot.current_names.length}"
