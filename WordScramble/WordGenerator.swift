import Foundation

struct WordGenerator {
    
    static let shared = WordGenerator()
    let words: [String]
    
    private init() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"),
            let startWords = try? String(contentsOf: startWordsURL) {
            self.words = startWords.components(separatedBy: "\n")
        } else {
            fatalError("Failed to load start.txt from bundle")
        }
        
    }
    
    func generate() -> String {
        return words.randomElement() ?? "silkworm"
    }
    
}
