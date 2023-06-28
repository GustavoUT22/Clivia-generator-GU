require_relative "clivia_generator"
module Requester
  def select_main_menu_action
    options_of_list = ["random", "scores", "exit"]
    gets_option(prompt: options_of_list, options: options_of_list)
    
  end
                 # @question => {key: "value"}
  def ask_question(question)
    array_questions = question[:results]
    score = 0
    array_questions.each do |question|
      decode_question = HTMLEntities.new.decode(question[:question])
      puts "Category: #{question[:category]} | Difficulty: #{question[:difficulty]}"
      puts "Question: #{decode_question}"

      all_answers = [question[:correct_answer]] + question[:incorrect_answers]
      decode_answers = all_answers.map { |answer| HTMLEntities.new.decode(answer) }
      suffled_answers = decode_answers.shuffle
      suffled_answers.each_with_index do |answer, index|
        puts "#{index + 1}. #{answer}"
      end
        user_answer_integer = ""
        print "> "
        user_answer_integer = gets.chomp.to_i #1 #[1,2,3,4][0]   user_answer_integer = 1
        @user_answer = suffled_answers[user_answer_integer - 1] #=> 1

        if @user_answer == question[:correct_answer]
          puts "Correct"
          score += 10
        else   
          puts "#{@user_answer}...Incorrect!"
          puts "The correct answer was: #{question[:correct_answer]}"
        end
    end
    will_save?(score)
  end 

  def will_save?(score)
    print_score(score)
    puts "--------------------------------------------------"
    options = ["y", "n"]
    input = ""
    loop  do
      puts "Do you want to save score? (#{options.join("/")})"
      print "> "
    input = gets.chomp.downcase
    break if options.include?(input) 
    puts "Invalid option"
    end
    
    case input
    when "n"
      print_welcome
    when "y"
      puts "Type the name tpo assign to the score"
      print "> "
      name = gets.chomp.capitalize
      name = "Anonymus" if name == ""
      data = { score: score, name: name }
      save(data)
    end
   
  end

  def gets_option(prompt: , options:)
    input = ""
    loop do 
      puts options.join(" | ")
      print "> "
      input = gets.chomp.strip
      break if options.include?(input)
      puts "Invalid option"
    end
    input

  end
end
