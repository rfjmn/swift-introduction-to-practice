func throwableFunction(throwsError: Bool) throws {
    if throwsError {
        throw SomeError()
    }
}
