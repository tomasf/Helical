import Testing
@testable import Helical
import Cadova

private func isClose(_ a: Double, _ b: Double) -> Bool { abs(a - b) < 1e-9 }

struct LeadInTests {
    let m3 = ScrewThread.m3
    let m8 = ScrewThread.m8

    @Test func `constant(depth:length:) returns exact values`() {
        let (depth, length) = LeadIn.constant(depth: 0.5, length: 1.0).resolved(for: m3)
        #expect(depth == 0.5)
        #expect(length == 1.0)
    }

    @Test func `constant(depth:) produces depth == length`() {
        let (depth, length) = LeadIn.constant(depth: 0.3).resolved(for: m3)
        #expect(depth == 0.3)
        #expect(length == 0.3)
    }

    @Test func `depth(multiple:) scales by thread depth`() {
        let (d1, l1) = LeadIn.depth(multiple: 1).resolved(for: m3)
        #expect(isClose(d1, m3.depth))
        #expect(isClose(l1, m3.depth))

        let (d2, l2) = LeadIn.depth(multiple: 2).resolved(for: m8)
        #expect(isClose(d2, m8.depth * 2))
        #expect(isClose(l2, m8.depth * 2))
    }

    @Test func `pitch(multiple:) scales by thread pitch`() {
        let (d1, l1) = LeadIn.pitch(multiple: 1).resolved(for: m3)
        #expect(d1 == 0.5)
        #expect(l1 == 0.5)

        let (d2, l2) = LeadIn.pitch(multiple: 0.5).resolved(for: m8)
        #expect(d2 == 0.625)
        #expect(l2 == 0.625)
    }

    @Test func `angle(90°) produces 45° chamfer: depth == length`() {
        let (depth, length) = LeadIn.angle(90°).resolved(for: m3)
        #expect(isClose(depth, m3.depth))
        #expect(isClose(length, depth))
    }

    @Test func `angle(120°) produces length = depth × tan(30°)`() {
        let (depth, length) = LeadIn.angle(120°).resolved(for: m3)
        #expect(isClose(depth, m3.depth))
        #expect(isClose(length, depth * tan(30°)))
    }

    @Test func `standard equals depth(multiple: 1)`() {
        let (d1, l1) = LeadIn.standard.resolved(for: m3)
        let (d2, l2) = LeadIn.depth(multiple: 1).resolved(for: m3)
        #expect(d1 == d2)
        #expect(l1 == l2)
    }
}
