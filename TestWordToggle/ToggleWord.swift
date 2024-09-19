//
//  ToggleWord.swift
//  TestWordToggle
//
//  Created by Leonore Yardimli on 2024/9/19.
//

import Foundation
struct ToggledWord: Identifiable, Codable {
	var id: Int
	let word: String
	var highlighted: Bool
	
	enum CodingKeys: String, CodingKey {
		case word, highlighted
	}
	
	init(id: Int, word: String, highlighted: Bool) {
		self.id = id
		self.word = word
		self.highlighted = highlighted
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		word = try container.decode(String.self, forKey: .word)
		highlighted = try container.decode(Bool.self, forKey: .highlighted)
		id = 0 // This will be set correctly when decoding the whole array
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(word, forKey: .word)
		try container.encode(highlighted, forKey: .highlighted)
	}
}

struct ToggledWordSentence: Codable {
	var sentence: String
	var words: [ToggledWord]
	
	init(sentence: String, words: [ToggledWord]) {
		self.sentence = sentence
		self.words = words
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		sentence = try container.decode(String.self, forKey: .sentence)
		var wordsArray = try container.nestedUnkeyedContainer(forKey: .words)
		var words: [ToggledWord] = []
		var index = 0
		while !wordsArray.isAtEnd {
			var word = try wordsArray.decode(ToggledWord.self)
			word.id = index
			words.append(word)
			index += 1
		}
		self.words = words
	}
}
