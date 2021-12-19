import Foundation

enum RequestResult<T> {
    case success(T)
    case failure(NetworkError)
}
