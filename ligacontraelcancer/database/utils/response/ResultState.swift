import Foundation

enum ResultState<T>{
    case success(T)
    case failure(ErrorState)
    
    static func from(
        _ operation: @escaping () async throws -> T
        ) async -> ResultState<T> {
            do {
                let result = try await operation()
                return .success(result)
            } catch {
                let mappedError = ErrorMapperRegistry.map(error)
                return .failure(mappedError)
            }
    }
}
