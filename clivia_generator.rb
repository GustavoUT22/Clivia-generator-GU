
require_relative "presenter"
require_relative "requester"
require "httparty"
require "json"
require "pry"
require "htmlentities"
require "terminal-table"
class CliviaGenerator

include Presenter
include Requester

BASE_URL = "https://opentdb.com/api.php?amount=10"

  def initialize(filename)
    @filename = filename
    @questions = []
    @user_score = parse_scores
  end

  def start
    print_welcome
    action = ""
    until action == "exit"
    action = select_main_menu_action
      case action
      when "random" then random_trivia
      when "scores" then  puts print_scores
      when "exit" then puts "Thanks for using Clivia generator"
      end
    end

  end

  def random_trivia
    # load the questions from the api
    load_questions
    # questions are loaded, then let's ask them
    ask_questions
    
  end

  def ask_questions
    ask_question(@questions)
  end
  
  def save(data)
    @user_score << data
    File.write(@filename, JSON.pretty_generate(@user_score))
    data
  end

  def parse_scores
    begin
    #get scores from data file
    JSON.parse(File.read(@filename), symbolize_names: true)
    rescue JSON::ParserError
    Array.new
    end
  end

  
  def load_questions
    # ask the api for a random set of questions
    response = HTTParty.get(BASE_URL)
    @questions = JSON.parse(response.body, symbolize_names: true)
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end

  def print_scores
    table = Terminal::Table.new 
    table.title = "Top Scores"
    table.headings = ["name", "score"]
    table.rows = @user_score.map do |data|
      [data[:name], data[:score]]
    end
    table
  end
end
