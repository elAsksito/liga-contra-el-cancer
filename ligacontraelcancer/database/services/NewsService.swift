import Foundation
import FirebaseFirestore
import FirebaseFirestore
import FirebaseStorage
import UIKit

class NewsService {
    
    static let shared = NewsService()
    private init () {}
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var newsCollection: CollectionReference {
        return db.collection("news")
    }
    
    func saveNews(_ news: News, image: UIImage?) async -> ResultState<String> {
        do {
            let docRef = newsCollection.document()
            let newsId = docRef.documentID

            var imageUrl: String = news.image
            if let image = image {
                if let uploadedUrl = try await uploadImage(image: image, newsId: newsId) {
                    imageUrl = uploadedUrl
                }
            }

            var newsWithId = news
            newsWithId.id = newsId
            newsWithId.image = imageUrl

            
            try docRef.setData(from: newsWithId)
            return .success("Noticia guardada correctamente con ID: \(newsId)")
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func getNewsById(_ id: String) async -> ResultState<News> {
        do {
            let doc = try await newsCollection.document(id).getDocument()
            if doc.exists {
                let news = try doc.data(as: News.self)
                    return .success(news)
            } else {
                return .failure(.customError("No se encontró la noticia."))
            }
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func getAllNews() async -> ResultState<[News]> {
        do {
            let snapshot = try await newsCollection.getDocuments()
            let newsList = try snapshot.documents.compactMap {
                try $0.data(as: News.self)
            }
            return .success(newsList)
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func deleteNews(_ id: String) async -> ResultState<String> {
        do {
            try await newsCollection.document(id).delete()
            return .success("Noticia eliminada correctamente.")
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    private func uploadImage(image: UIImage, newsId: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        let ref = storage.reference().child("news/\(newsId).jpg")
        _ = try await ref.putDataAsync(imageData, metadata: nil)
        let url = try await ref.downloadURL()
        return url.absoluteString
    }
}
