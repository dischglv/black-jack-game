module ConsoleUI
  class << self
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
  end
end