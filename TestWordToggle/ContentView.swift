//
//  ContentView.swift
//  TestWordToggle
//
//  Created by Leonore Yardimli on 2024/9/10.
//

import SwiftUI

struct Word: Identifiable, Codable {
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

struct Sentence: Codable {
	var sentence: String
	var words: [Word]
	
	init(sentence: String, words: [Word]) {
		self.sentence = sentence
		self.words = words
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		sentence = try container.decode(String.self, forKey: .sentence)
		var wordsArray = try container.nestedUnkeyedContainer(forKey: .words)
		var words: [Word] = []
		var index = 0
		while !wordsArray.isAtEnd {
			var word = try wordsArray.decode(Word.self)
			word.id = index
			words.append(word)
			index += 1
		}
		self.words = words
	}
}

class SentenceViewModel: ObservableObject {
	@Published var sentence: Sentence {
		didSet {
			updateJSONString()
		}
	}
	@Published var jsonString: String = ""
	
	init() {
		self.sentence = Sentence(sentence: "", words: [])
		loadData()
	}
	
	func loadData() {
		let jsonString = """
		 {
		 "sentence":"We can go out for a walk now.",
		 "words":[
		 {"word":"We","highlighted":true},
		 {"word":"can","highlighted":false},
		 {"word":"go out","highlighted":true},
		 {"word":"for","highlighted":false},
		 {"word":"a","highlighted":false},
		 {"word":"walk","highlighted":true},
		 {"word":"now.","highlighted":true}
		 ]
		 }
		 """
		
		if let jsonData = jsonString.data(using: .utf8) {
			do {
				let decoder = JSONDecoder()
				self.sentence = try decoder.decode(Sentence.self, from: jsonData)
				updateJSONString()
			} catch {
				print("Error parsing JSON: \(error)")
			}
		}
	}
	
	func toggleHighlight(for word: Word) {
		if let index = sentence.words.firstIndex(where: { $0.id == word.id }) {
			sentence.words[index].highlighted.toggle()
			updateJSONString()
		}
	}
	
	private func updateJSONString() {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
		
		do {
			let jsonData = try encoder.encode(sentence)
			if let jsonString = String(data: jsonData, encoding: .utf8) {
				self.jsonString = jsonString
			}
		} catch {
			print("Error encoding to JSON: \(error)")
		}
	}
}

struct ContentView: View {
	@StateObject private var viewModel = SentenceViewModel()
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		GeometryReader { geometry in
			VStack(alignment: .leading, spacing: 20) {
				Text("Sentence:")
					.font(.system(size: 24, weight: .bold))
				
				wordFlow
				
				Divider()
				
				Text("JSON Debug:")
					.font(.headline)
				
				ScrollView {
					Text(viewModel.jsonString)
						.font(.system(.body, design: .monospaced))
						.padding()
						.background(Color.gray.opacity(0.1))
						.cornerRadius(8)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.background(Color.gray.opacity(0.05))
			}
			.padding()
			.frame(height: geometry.size.height)
		}
	}
	
	private var wordFlow: some View {
		Text(attributedString)
			.lineSpacing(14) // Adjust line spacing as needed
			.environment(\.openURL, OpenURLAction { url in
				handleTap(url)
				return .handled
			})
	}
	
	private var attributedString: AttributedString {
		var result = AttributedString()
		
		for (index, word) in viewModel.sentence.words.enumerated() {
			var attributedWord = AttributedString(word.word)
			
			// Apply bold if needed and set larger font size
			let fontSize: CGFloat = 33 // Adjust this value to make text bigger
			
			if word.highlighted {
				// Bold and red for bold words
				attributedWord.font = .boldSystemFont(ofSize: fontSize)
				attributedWord.foregroundColor = .red
			} else {
				// Normal weight and black for non-bold words
				attributedWord.font = .systemFont(ofSize: fontSize)
				attributedWord.foregroundColor = colorScheme == .light ? .black : .white
			}
			
			//attributedWord.font = word.bold ?
			//		.boldSystemFont(ofSize: fontSize) :
			//		.systemFont(ofSize: fontSize)
			
			// Set text color to black
			//attributedWord.foregroundColor = colorScheme == .light ? .black : .white
			
			// Apply underline
			//attributedWord.underlineStyle = .single
			//attributedWord.underlineColor = .black
			
			// Add tap gesture
			attributedWord.link = URL(string: "word://\(index)")
			
			// Add more space after each word
			if index < viewModel.sentence.words.count - 1 {
				attributedWord += AttributedString("   ") // Three spaces for more separation
			}
			
			result += attributedWord
		}
		
		return result
	}
	
	private func handleTap(_ url: URL) {
		guard url.scheme == "word",
					let index = Int(url.host ?? ""),
					index < viewModel.sentence.words.count else { return }
		
		viewModel.toggleHighlight(for: viewModel.sentence.words[index])
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
