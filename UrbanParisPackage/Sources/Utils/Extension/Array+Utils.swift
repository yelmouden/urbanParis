import Foundation

public extension Array {
    subscript (safe index: Index) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }
        set {
            guard let value = newValue, indices.contains(index) else { return }
            self[index] = value
        }
    }
}
