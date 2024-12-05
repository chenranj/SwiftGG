import Foundation

@MainActor
class PostListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var hasMorePages = true
    @Published var isLoadingFailed = false
    
    private var currentPage = 1
    private var hasLoadedInitialData = false
    private var currentTask: Task<Void, Never>?
    
    func fetchPosts() async {
        guard !isLoading else { return }
        
        isLoading = true
        currentPage = 1
        isLoadingFailed = false
        
        do {
            let result = try await WordPressAPI.shared.fetchPosts()
            self.posts = result.posts
            self.hasMorePages = result.hasMore
            self.hasLoadedInitialData = true
        } catch {
            print("Error fetching posts: \(error)")
            self.isLoadingFailed = true
        }
        
        self.isLoading = false
    }
    
    func loadMorePosts() async {
        guard hasMorePages, !isLoadingMore, !isLoadingFailed else { return }
        
        isLoadingMore = true
        let nextPage = currentPage + 1
        
        do {
            let result = try await WordPressAPI.shared.fetchPosts(page: nextPage)
            if !result.posts.isEmpty {
                self.posts.append(contentsOf: result.posts)
                self.currentPage = nextPage
            }
            self.hasMorePages = result.hasMore
        } catch WordPressAPI.Error.noMorePages {
            self.hasMorePages = false
        } catch {
            print("Error loading more posts: \(error)")
            self.isLoadingFailed = true
        }
        
        self.isLoadingMore = false
    }
    
    func checkAndLoadInitialDataIfNeeded() async {
        guard !hasLoadedInitialData && posts.isEmpty else { return }
        await fetchPosts()
    }
    
    func retry() async {
        isLoadingFailed = false
        if posts.isEmpty {
            await fetchPosts()
        } else {
            await loadMorePosts()
        }
    }
} 
