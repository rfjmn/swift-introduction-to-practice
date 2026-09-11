import Dispatch

func getIntAsync(completion: @escaping (Int) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
        completion(4)
    }
}
