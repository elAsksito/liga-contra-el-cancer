struct DefaultErrorMapper: ErrorMappable {
    func mapError(_ error: Error) -> ErrorState {
        return .unknownError(error.localizedDescription)
    }
}
