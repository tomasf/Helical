import Foundation
import Cadova

internal struct SolidThreadform: Threadform {
    var body: any Geometry2D {
        @Environment(\.thread!) var thread
        Rectangle(x: thread.depth, y: thread.pitch)
    }

    func pitchDiameter(for thread: ScrewThread) -> Double {
        thread.majorDiameter
    }
}
