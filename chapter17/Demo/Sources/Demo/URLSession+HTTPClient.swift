import Foundation

extension URLSession: HTTPClient {
    public func fetchContents(of url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        
        let task = dataTask(with: url) { data, urlResponse, error in
            switch(data, urlResponse, error) {
            case (let data?, let urlResponse as HTTPURLResponse, _):
                completion(.success((data, urlResponse)))
                
            case (_, _, let error?):
                completion(.failure(error))
                
            default:
                fatalError()
            }
        }
        
        task.resume()
    }
}
