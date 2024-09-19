//
//  SentenceViewModel.swift
//  TestWordToggle
//
//  Created by Leonore Yardimli on 2024/9/19.
//

import Foundation

class SentenceViewModel: ObservableObject {
	@Published var toggledSentence: ToggledWordSentence
	
	init() {
		// Initialize with an empty sentence
		self.toggledSentence = ToggledWordSentence(sentence: "", words: [])
	}
	
	func createToggledWordSentence(from sentence: String) {
		// Split the sentence into an array of words
		let wordsArray = sentence.components(separatedBy: .whitespacesAndNewlines)
			.filter { !$0.isEmpty }
		
		// Create an array of ToggledWord structs
		let toggledWords = wordsArray.enumerated().map { index, word in
			ToggledWord(id: index, word: word, highlighted: false)
		}
		
		// Create and set the ToggledWordSentence
		toggledSentence = ToggledWordSentence(sentence: sentence, words: toggledWords)
	}
	
	func toggleHighlight(for word: ToggledWord) {
		var words = toggledSentence.words
		if let index = words.firstIndex(where: { $0.id == word.id }) {
			words[index].highlighted.toggle()
			toggledSentence.words = words
		}
	}
	
}
