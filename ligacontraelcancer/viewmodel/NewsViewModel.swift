import Foundation
import Combine

@MainActor
class NewsViewModel: ObservableObject {
    
    @Published var saveNewsState: ResultState<String> = .idle
    @Published var getNewsState: ResultState<News> = .idle
    @Published var getAllNewsState: ResultState<[News]> = .idle
    @Published var deleteNewsState: ResultState<String> = .idle
    
    func saveNews(_ news: News, image: UIImage?) {
        self.saveNewsState = .loading
        
        Task {
            let result = await NewsService.shared.saveNews(news, image: image)
            self.saveNewsState = result
        }
    }
    
    func getNewsById(_ id: String) {
        self.getNewsState = .loading
        
        Task {
            let result = await NewsService.shared.getNewsById(id)
            self.getNewsState = result
        }
    }
    
    func getAllNews() {
        self.getAllNewsState = .loading
        
        Task {
            let result = await NewsService.shared.getAllNews()
            self.getAllNewsState = result
        }
    }
    
    func deleteNews(_ id: String) {
        self.deleteNewsState = .loading
        
        Task {
            let result = await NewsService.shared.deleteNews(id)
            self.deleteNewsState = result
        }
    }
}
