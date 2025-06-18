import Foundation
import Cadova

// A bolt head shape for bolts without a head, such as set screws

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
    public var body: any Geometry3D {}
    public var recess: any Geometry3D {}
}
