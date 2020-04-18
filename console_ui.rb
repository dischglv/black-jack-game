module ConsoleUI
  class << self
    def puts(msg)
      puts msg
    end

    def print(msg)
      print(msg)
    end

    def request(msg)
      print(msg)
      gets.chomp
    end

    def ask(msg)
      request("#{msg} [дн] ") == 'д'
    end

    # принимает хэш, у которого ключи - строки
    def hash_choose(item, options)
      options.each_with_index do |option, index|
        puts "[#{index + 1}] #{option.first}"
        options_names ||= []
        options_names << options.first
      end
      choice = request("Выберите #{item} и введите его номер: ")
      choice_name = options_names[choice - 1]
      result = options[choice_name]
      result
    end
  end
end