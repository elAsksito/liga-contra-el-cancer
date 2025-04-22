import Foundation

enum ResultState<T> {
    case idle
    case loading
    case success(T)
    case failure(ErrorState)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var value: T? {
        if case .success(let value) = self { return value }
        return nil
    }

    var error: ErrorState? {
        if case .failure(let error) = self { return error }
        return nil
    }
}
