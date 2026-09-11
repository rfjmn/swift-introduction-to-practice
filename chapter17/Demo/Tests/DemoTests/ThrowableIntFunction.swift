@testable import Demo


func throwableIntFunction(throwsError: Bool) throws -> Int {
    if throwsError {
        throw SomeError()
    }
    
    return 7
}
