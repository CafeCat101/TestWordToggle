//
//  ContentView.swift
//  TestWordToggle
//
//  Created by Leonore Yardimli on 2024/9/10.
//

/*
import SwiftUI


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
					Text(viewModel.userSentenceJson)
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
		
		for (index, word) in viewModel.userSentenceObj.words.enumerated() {
			var attributedWord = AttributedString(word.word)
			
			// Apply bold if needed and set larger font size
			let fontSize: CGFloat = 33 // Adjust this value to make text bigger
			
			if word.highlighted {
				// Bold and red for bold words
				attributedWord.font = .systemFont(ofSize: fontSize, weight: .heavy)
				//attributedWord.foregroundColor = .red
			} else {
				// Normal weight and black for non-bold words
				attributedWord.font = .systemFont(ofSize: fontSize, weight: .regular)
				//attributedWord.foregroundColor = colorScheme == .light ? .black : .white
			}
			
			//attributedWord.font = word.bold ?
			//		.boldSystemFont(ofSize: fontSize) :
			//		.systemFont(ofSize: fontSize)
			
			// Set text color to black
			attributedWord.foregroundColor = colorScheme == .light ? .black : .white
			
			// Apply underline
			//attributedWord.underlineStyle = .single
			//attributedWord.underlineColor = .black
			
			// Add tap gesture
			attributedWord.link = URL(string: "word://\(index)")
			
			// Add more space after each word
			if index < viewModel.userSentenceObj.words.count - 1 {
				attributedWord += AttributedString("   ") // Three spaces for more separation
			}
			
			result += attributedWord
		}
		
		return result
	}
	
	private func handleTap(_ url: URL) {
		guard url.scheme == "word",
					let index = Int(url.host ?? ""),
					index < viewModel.userSentenceObj.words.count else { return }
		
		viewModel.toggleHighlight(for: viewModel.userSentenceObj.words[index])
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}



*/
