import Foundation
import SwiftSCAD

public struct ChamferedBoltHeadShape: BoltHeadShape {
    let thread: ScrewThread
    let edgeProfile: EdgeProfile

    public init(thread: ScrewThread, edgeProfile: EdgeProfile) {
        self.thread = thread
        self.edgeProfile = edgeProfile
    }

    public var negativeBody: any Geometry3D {
        EnvironmentReader { environment in
            edgeProfile.shape()
                .translated(x: (thread.majorDiameter - environment.tolerance) / 2)
                .extruded()
        }
    }

    public let height = 0.0
    public let body: any Geometry3D = Box(.zero)
    public let recess: (any BoltHeadRecess)? = nil
}
