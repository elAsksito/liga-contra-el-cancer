protocol ErrorMappable{
    func mapError(_ error: Error) -> ErrorState
}
