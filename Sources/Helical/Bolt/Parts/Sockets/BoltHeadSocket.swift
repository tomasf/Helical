import Foundation
import Cadova

/// A protocol defining the drive socket geometry in a bolt head.
public protocol BoltHeadSocket: Shape3D {
    /// Depth of the socket recess.
    var depth: Double { get }
}
