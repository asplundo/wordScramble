import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var score: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                Text("Score: \(score)")
            }
            .navigationBarTitle(rootWord)
            .navigationBarItems(leading: Button("Restart", action: startGame))
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func startGame() {
        rootWord = WordGenerator.shared.generate()
        usedWords.removeAll()
        score = 0
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        let validator = WordValidator(usedWords: usedWords, rootWord: rootWord, word: answer)
        
        let result = validator.validate()
        switch result {
        case .success:
            usedWords.insert(answer, at: 0)
            score += updateScore(for: newWord)
            newWord = ""
        case .failure(let error):
            switch error {
            case .validationError(let title, let message):
                wordError(title: title, message: message)
            }
        }
    }
    
    func updateScore(for word: String) -> Int {
        var scoreForWord = 0
        for letter in word {
            switch letter {
            case "a", "o", "u", "e", "i", "y":
                scoreForWord += 2
            default:
                scoreForWord += 1
            }
        }
        return scoreForWord
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
