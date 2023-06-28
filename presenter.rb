module Presenter
  def print_welcome
   puts ["#"*35,"#   Welcome to Clivia Generator   #","#"*35].join("\n")
  end

  def print_score(score)
    puts "Well done! Your score is #{score}"
  end
end
