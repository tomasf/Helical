import Testing
@testable import Helical
import Cadova

private func isClose(_ a: Double, _ b: Double) -> Bool { abs(a - b) < 1e-9 }

struct ScrewThreadTests {
    @Test func `depth is (majorDiameter - minorDiameter) / 2`() {
        // M3: major=3.0, minor=3.0 - 0.5*1.082532 = 2.458734
        #expect(isClose(ScrewThread.m3.depth, 0.270633))

        // Custom thread with exact integer values
        let t = ScrewThread(pitch: 1.5, majorDiameter: 10, minorDiameter: 8, form: .trapezoidal(angle: 60°, crestWidth: 0.125))
        #expect(t.depth == 1.0)
    }

    @Test func `lead is starts × pitch`() {
        #expect(ScrewThread.m3.lead == 0.5)

        // 3-start ACME thread: lead = 3 × 4 = 12
        let t = ScrewThread.acme(majorDiameter: 20, pitch: 4, starts: 3)
        #expect(t.lead == 12.0)
    }

    @Test func `leftHanded reflects handedness`() {
        #expect(ScrewThread.m3.leftHanded == false)
        let left = ScrewThread(handedness: .left, pitch: 0.5, majorDiameter: 3, minorDiameter: 2.458734, form: .trapezoidal(angle: 60°, crestWidth: 0.0625))
        #expect(left.leftHanded == true)
    }
}
