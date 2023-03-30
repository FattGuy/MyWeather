import Foundation

class MockURLProtocol: URLProtocol {
    static var mockResponseData: Data?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        // Check if mock response data is set
        guard let mockData = MockURLProtocol.mockResponseData else {
            fatalError("Mock data not set")
        }
        
        // Return mock response
        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocol(self, didLoad: mockData)
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
