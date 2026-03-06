import Testing
@testable import Helical
import Cadova

private func isClose(_ a: Double, _ b: Double, tolerance: Double = 1e-9) -> Bool { abs(a - b) < tolerance }

// These tests verify that factory methods wire geometry correctly:
// the table-sourced topDiameter feeds through the countersink height formula,
// so a wrong table value or a wrong boltDiameter argument produces a wrong height.

struct HexSocketCountersunkTests {
    // boltDiameter = thread.majorDiameter (not majorDiameter - depth)
    @Test func `head height uses major diameter as bolt diameter`() {
        let m4  = Bolt.hexSocketCountersunk(.m4,  length: 20)
        let m10 = Bolt.hexSocketCountersunk(.m10, length: 30)
        // topDiameter=7.53, boltDiameter=4.0 → (7.53-4.0)/2 * tan(45°) ≈ 1.765
        #expect(isClose(m4.headShape.height,  1.765, tolerance: 1e-4))
        // topDiameter=19.22, boltDiameter=10.0 → (19.22-10.0)/2 ≈ 4.61
        #expect(isClose(m10.headShape.height, 4.61,  tolerance: 1e-4))
    }
}

struct TorxCountersunkTests {
    // boltDiameter = majorDiameter - depth (not majorDiameter)
    @Test func `head height uses reduced bolt diameter`() {
        let m3 = Bolt.torxCountersunk(.m3, length: 20)
        let m8 = Bolt.torxCountersunk(.m8, length: 30)
        #expect(isClose(m3.headShape.height, (5.5  - (ScrewThread.m3.majorDiameter - ScrewThread.m3.depth)) / 2, tolerance: 1e-6))
        #expect(isClose(m8.headShape.height, (15.8 - (ScrewThread.m8.majorDiameter - ScrewThread.m8.depth)) / 2, tolerance: 1e-6))
    }
}

struct SlottedCountersunkTests {
    // Same reduced boltDiameter convention as Torx
    @Test func `head height uses reduced bolt diameter`() {
        let m3  = Bolt.slottedCountersunk(.m3,  length: 20)
        let m10 = Bolt.slottedCountersunk(.m10, length: 30)
        #expect(isClose(m3.headShape.height,  (5.6  - (ScrewThread.m3.majorDiameter  - ScrewThread.m3.depth))  / 2, tolerance: 1e-6))
        #expect(isClose(m10.headShape.height, (18.0 - (ScrewThread.m10.majorDiameter - ScrewThread.m10.depth)) / 2, tolerance: 1e-6))
    }
}
