class ConsoleUI
  # принимает хэш, у которого ключи - строки
  def hash_choose(item, options)
    options_names = []

    options.each_with_index do |option, index|
      puts "[#{index + 1}] #{option.first}"
      options_names << option.first
    end
    
    choice = request("Выберите #{item} и введите его номер: ")
    choice_name = options_names[choice.to_i - 1]
    result = options[choice_name]
    result
  end

  def show_game_status(players, game)
    status = "----------------------------------\n"
    status += "Банк игры: #{game.bank.money}$\n"

    players.each { |player| status += "Банк #{player.name}: #{player.bank.money}$\n" }

    players.each do |player|
      if player.is_a?(UserPlayer) || (player.is_a?(ComputerPlayer) && game.cards_opened?)
        status += "#{player.name}:  "
        player.hand.cards.each { |card| status += "#{card} " }
        status += "  всего очков: #{player.hand.points}\n"
      elsif player.is_a?(ComputerPlayer) && !game.cards_opened?
        status += "#{player.name}:  "
        player.hand.cards.each { |card| status += "\uf0a0 " }
        status += "\n"
      end
    end
    status += "----------------------------------\n"

    puts(status)
  end

  def request_user_name
    request('Введите имя пользователя: ')
  end

  def puts_final_report(winners, losers)
    report = ""

    if winners.length > 1
      report += "Игроки "
      winners.each { |winner| report += "#{winner.name} "}
      report += "сыграли ничью \n"
    elsif winners.length == 1
      report += "Игрок #{winners.first.name} выиграл\n"
    end

    if losers.length > 0
      losers.each { |loser| report += "Игрок #{loser.name} проиграл\n" }
    end

    puts(report)
  end

  def ask_play_more
    ask('Хотите сыграть еще раз?')
  end

  def inform_player_move(player)
    puts("Ход игрока #{player.name}...")
  end

  def inform_game_over
    puts('Игра закончена!')
  end

  private

  def puts(msg)
    Kernel.puts msg
  end

  def print(msg)
    Kernel.print(msg)
  end

  def request(msg)
    print(msg)
    Kernel.gets.chomp
  end

  def ask(msg)
    request("#{msg} [дн] ") == 'д'
  end
end