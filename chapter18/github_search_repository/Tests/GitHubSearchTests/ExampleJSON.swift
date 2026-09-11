import GitHubSearch

extension User {
    static var exampleJSON: String {
        return """
        {
            "login": "apple",
            "id": 10639145
        }
        """
    }
}

extension Repository {
    static var exampleJSON: String {
        return """
        {
          "id":44838949,
          "name":"swift",
          "full_name":"apple/swift",
          "owner": {
             "login":"apple",
             "id":10639145
          }
        }
        """
    }
}

/*
 ジェネリクスをItem == Repositoryで特殊化している
 */
extension SearchResponse where Item == Repository {
    static var exampleJSON: String {
        return """
        {
            "total_count": 141722,
            "items": [
                {
                    "id": 44838949,
                    "full_name": "apple/swift",
                    "name": "swift",
                    "owner": {
                        "id": 10639145,
                        "login": "apple"
                    }
                },
                {
                    "id": 790019,
                    "full_name": "openstack/swift",
                    "name": "swift",
                    "owner": {
                        "id": 324574,
                        "login": "openstack"
                    }
                },
                {
                    "id": 20822291,
                    "name": "swiftGuide",
                    "full_name": "ipader/SwiftGuide",
                    "owner": {
                        "id": 575016,
                        "login": "ipader",
                    }
                },
            ]
        }
        """
    }
}

extension GitHubAPIError {
    static var exampleJSON: String {
        return """
        {
            "message": "Validation Failed",
            "errors": [
                {
                    "resource": "Search",
                    "field": "q",
                    "code": "missing"
                }
            ],
            "documentation_url": "https://developer.github.com/v3/search"
        }
        """
    }
}
