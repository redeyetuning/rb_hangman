#Hangman is a paper and pencil guessing game for two or more players. One player thinks of a word, 
#phrase or sentence and the other tries to guess it by suggesting letters or numbers, within a certain number of guesses.



def load_dictionary
	raise StandardError, "Dictionary file not found!" unless File.exist? "dictionary.txt"
	puts "Dictionary file loaded."
	File.readlines "dictionary.txt"
end

def pick_word(dictionary)
dictionary.sample
end

def show_display_word(word)
	display_word ||= Array.new(word.length){"_"}
	print display_word.join(" ")
end

dictionary = load_dictionary
word = pick_word(dictionary)
print word
display_word = show_display_word(word)