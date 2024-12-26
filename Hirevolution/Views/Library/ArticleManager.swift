import FirebaseFirestore
import Firebase

class ArticleManager {
    
    static let shared = ArticleManager()
    
    private var articles: [Article] = []
    
    private let db = Firestore.firestore()
    
    // Method to fetch articles from Firestore and store them in memory
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        // Check if articles are already loaded in memory
        if !articles.isEmpty {
            completion(.success(articles))
            return
        }
        
        // Fetch articles from Firestore if not loaded
        db.collection("Article").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var fetchedArticles: [Article] = []
            
            // Loop through the documents in the snapshot
            for document in snapshot!.documents {
                do {
                    // Ensure we correctly decode the article document using the model
                    let article = try document.data(as: Article.self)
                    fetchedArticles.append(article)
                } catch {
                    // If decoding fails, return an error
                    completion(.failure(error))
                    return
                }
            }
            
            // Store the fetched articles in memory
            self.articles = fetchedArticles
            completion(.success(fetchedArticles))
        }
    }
    
    // Method to get all articles from memory (if they were already fetched)
    func getAllArticles() -> [Article] {
        return articles
    }
    
    // Method to get a specific article by its title
    func getArticle(byTitle title: String) -> Article? {
        return articles.first { $0.Title == title }
    }
    
    // Method to get articles by topic (e.g., "Interview Tips")
    func getArticles(byTopic topic: String) -> [Article] {
        return articles.filter { $0.Topic == topic }
    }
}

// Content model for each section's header and content
struct ArticleContent: Codable {
    var Header: String
    var Content: String
}

// Article model for a full article document
struct Article: Codable {
    var Title: String
    var Topic: String
    var Date: String // Store as String after converting the Timestamp from Firestore
    var Article: [ArticleContent]
    
    enum CodingKeys: String, CodingKey {
        case Title
        case Topic
        case Date
        case Article
    }
    
    // Custom Decoding Logic for Date (Timestamp -> String)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode basic fields
        self.Title = try container.decode(String.self, forKey: .Title)
        self.Topic = try container.decode(String.self, forKey: .Topic)
        self.Article = try container.decode([ArticleContent].self, forKey: .Article)
        
        // Decode the Timestamp and convert to String (use Timestamp directly)
        let timestamp = try container.decode(Timestamp.self, forKey: .Date)
        self.Date = timestamp.dateValue().toString() // Convert Timestamp to String
    }
}

// Extension to convert Date to String
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
