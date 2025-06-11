import Foundation
import Cadova

public struct ChamferedBoltHeadShape: BoltHeadShape {
    let thread: ScrewThread
    let edgeProfile: EdgeProfile

    public init(thread: ScrewThread, edgeProfile: EdgeProfile) {
        self.thread = thread
        self.edgeProfile = edgeProfile
    }

    public var negativeBody: any Geometry3D {
        readTolerance { tolerance in
            edgeProfile.profile
                .translated(x: (thread.majorDiameter - tolerance) / 2)
                .revolved()
        }
    }

    public let height = 0.0
    public let body: any Geometry3D = Box(.zero)
    public let recess: (any Geometry3D)? = nil
}
