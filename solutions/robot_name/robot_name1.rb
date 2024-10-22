# Assumption: We won't run out of robot names?
# Could implement a flag if reaches max and raise error or prevent creating more if so? How many combos, 676000?

require 'faker'

class Robot

  # Class instance variable for keeping track of names
  @current_names = Set.new

  class << self
    attr_reader :current_names
  end

  # Instance variable, initialise as a placeholder rather than nil
  attr_reader :name

  DEFAULT_NAME = 'unnamed'.freeze

  def initialize
    @name = default_name
  end

  # Error, not sure where best to place it
  class DuplicateName < StandardError; end

  # First time boot up and add to list
  def boot_up
    if @name == DEFAULT_NAME
      @name = set_name
      add_entity
      'Booting up robot...'
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

  # Keeping methods private so cannot be called directly
  private

  def default_name
    @name = DEFAULT_NAME
  end

  # Generating the unique name, if already exists call the method again (will infinitely try which could be a problem)
  def set_name
    name = Faker::Base.regexify(/[A-Z]{2}[0-9]{3}/)
    raise DuplicateName if self.class.current_names.include?(name)

    @name = name
  rescue DuplicateName
    set_name
  end

  def add_entity
    self.class.current_names << @name
  end

  def remove_entity
    self.class.current_names.delete(@name)
  end
end

# Make a new robot
new_robot = Robot.new

# Robot placeholder name
puts new_robot.name

# Resetting robot before booting up
puts new_robot.reset_factory_settings

# Boot up robot
puts new_robot.boot_up

# Ask robot name
puts new_robot.ask_name

# Reset robot
puts new_robot.reset_factory_settings

# Ask name again (ask name will boot up if not already booted up)
puts new_robot.ask_name

# Different robot
newer_robot = Robot.new
puts newer_robot.ask_name

# List of all named robots
puts Robot.named_robots