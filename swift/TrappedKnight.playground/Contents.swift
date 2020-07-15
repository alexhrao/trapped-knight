import Cocoa

typealias Frame = Int;
typealias Index = Int;

struct Subscript {
    let row: Int;
    let col: Int;
};

var indices: Set<Index> = [ 0 ];

// Maintain order (and compatibility) for comparison with Sloane Sequence
var sloanIndices: [Index] = [ 1 ];

var knight = Subscript(row: 0, col: 0);

func frameIndex(sub: Subscript) -> Frame {
    return max(abs(sub.row), abs(sub.col));
}

func frameIndex(idx: Index) -> Frame {
    return Frame(round(sqrt(Double(idx)) / 2));
}

func area(_ f: Frame) -> Int {
    return (2*f - 1) * (2*f - 1);
}

func perimeter(_ f: Frame) -> Int {
    return 8*f;
}

func extrema(_ f: Frame) -> Index {
    return 4*f*(f + 1);
}

func base(_ f: Frame) -> Index {
    return 4*f*(f - 1) + 1;
}

func tag(_ f: Frame) -> Index {
    return 4 * f * f;
}

func sub2idx(sub: Subscript) -> Index {
    let f = frameIndex(sub: sub);
    let b = base(f);
    // special case!
    if sub.row == -f && sub.col == -f {
        return extrema(f);
    } else if sub.row == -f {
        return b + 1*f + sub.col - 1;
    } else if sub.col == f {
        return b + 3*f + sub.row - 1;
    } else if sub.row == f {
        return b + 5*f - sub.col - 1;
    } else if sub.col == -f {
        return b + 7*f - sub.row - 1;
    } else {
        return -1;
    }
}

func idx2sub(idx: Index) -> Subscript {
    let f = frameIndex(idx: idx);
    let b = base(f);
    let t = tag(f);
    let e = extrema(f);
    
    let r: Int;
    let c: Int;
    
    if b <= idx && idx < (b + 2*f) {
        r = -f;
        c = -f + (idx - b) + 1;
    } else if idx <= t {
        r = -f + (idx - (b + 2*f)) + 1;
        c = f;
    } else if idx <= (t + 2*f) {
        r = f;
        c = f + t - idx;
    } else if idx <= e {
        r = f - (idx - (t + 2*f));
        c = -f;
    } else {
        r = 0;
        c = 0;
    }
    
    return Subscript(row: r, col: c);
}

func destination(knight: Subscript, indices: Set<Index>) -> Index? {
    return [
        Subscript(row: knight.row + 1, col: knight.col + 2),
        Subscript(row: knight.row + 1, col: knight.col - 2),
        Subscript(row: knight.row - 1, col: knight.col + 2),
        Subscript(row: knight.row - 1, col: knight.col - 2),
        Subscript(row: knight.row + 2, col: knight.col + 1),
        Subscript(row: knight.row + 2, col: knight.col - 1),
        Subscript(row: knight.row - 2, col: knight.col + 1),
        Subscript(row: knight.row - 2, col: knight.col - 1),
        ].map(sub2idx(sub:))
        .filter { !indices.contains($0) }
        .min();
}

// Unit Testing
protocol UnitTest {
    associatedtype I;
    associatedtype O;
    
    var input: I { get };
    var output: O { get };
    func test() -> Bool;
}

// Unit Tests
struct FrameIndexSubscriptTest: UnitTest {
    let input: Subscript;
    let output: Frame;
    func test() -> Bool {
        let out = frameIndex(sub: input);
        if out != output {
            print("Expected: \(output); Got \(out) instead");
        }
        return out == output;
    }
};

struct FrameIndexIndexTest: UnitTest {
    let input: Index;
    let output: Frame;
    func test() -> Bool {
        let out = frameIndex(idx: input);
        if out != output {
            print("Expected: \(output); Got \(out) instead");
        }
        return out == output;
    }
};
func testFrameIndex() -> Bool {
    let subTests: [FrameIndexSubscriptTest] = [
        FrameIndexSubscriptTest(input: Subscript(row: 0, col: 0), output: 0),
        FrameIndexSubscriptTest(input: Subscript(row: 1, col: 1), output: 1),
        FrameIndexSubscriptTest(input: Subscript(row: 0, col: -2), output: 2),
        FrameIndexSubscriptTest(input: Subscript(row: 7, col: -7), output: 7),
        FrameIndexSubscriptTest(input: Subscript(row: 10, col: -15), output: 15),
    ];
    
    let idxTests: [FrameIndexIndexTest] = [
        FrameIndexIndexTest(input: 0, output: 0),
        FrameIndexIndexTest(input: 8, output: 1),
        FrameIndexIndexTest(input: 1, output: 1),
        FrameIndexIndexTest(input: 9, output: 2),
        FrameIndexIndexTest(input: 48, output: 3),
    ];
    
    for t in subTests {
        if !t.test() {
            return false;
        }
    }
    
    for t in idxTests {
        if !t.test() {
            return false;
        }
    }
    
    return true;
}

struct Sub2IdxTest: UnitTest {
    let input: Subscript;
    let output: Index;
    func test() -> Bool {
        let out = sub2idx(sub: input);
        if out != output {
            print("Expected: \(output); Got \(out) instead");
        }
        return out == output;
    }
}

func testSub2Idx() -> Bool {
    let tests: [Sub2IdxTest] = [
        Sub2IdxTest(input: Subscript(row: 0, col: 0), output: 0),
        Sub2IdxTest(input: Subscript(row: -1, col: 0), output: 1),
        Sub2IdxTest(input: Subscript(row: -1, col: 1), output: 2),
        Sub2IdxTest(input: Subscript(row: 0, col: 1), output: 3),
        Sub2IdxTest(input: Subscript(row: 1, col: 1), output: 4),
        Sub2IdxTest(input: Subscript(row: 1, col: 0), output: 5),
        Sub2IdxTest(input: Subscript(row: 1, col: -1), output: 6),
        Sub2IdxTest(input: Subscript(row: 0, col: -1), output: 7),
        Sub2IdxTest(input: Subscript(row: -1, col: -1), output: 8),
        Sub2IdxTest(input: Subscript(row: -2, col: -1), output: 9),
        Sub2IdxTest(input: Subscript(row: -2, col: 0), output: 10),
        Sub2IdxTest(input: Subscript(row: -2, col: 1), output: 11),
        Sub2IdxTest(input: Subscript(row: -2, col: 2), output: 12),
        Sub2IdxTest(input: Subscript(row: -1, col: 2), output: 13),
        Sub2IdxTest(input: Subscript(row: 0, col: 2), output: 14),
        Sub2IdxTest(input: Subscript(row: 1, col: 2), output: 15),
        Sub2IdxTest(input: Subscript(row: 2, col: 2), output: 16),
        Sub2IdxTest(input: Subscript(row: 2, col: 1), output: 17),
        Sub2IdxTest(input: Subscript(row: 2, col: 0), output: 18),
        Sub2IdxTest(input: Subscript(row: 2, col: -1), output: 19),
        Sub2IdxTest(input: Subscript(row: 2, col: -2), output: 20),
        Sub2IdxTest(input: Subscript(row: 1, col: -2), output: 21),
        Sub2IdxTest(input: Subscript(row: 0, col: -2), output: 22),
        Sub2IdxTest(input: Subscript(row: -1, col: -2), output: 23),
        Sub2IdxTest(input: Subscript(row: -2, col: -2), output: 24),
        Sub2IdxTest(input: Subscript(row: -3, col: -2), output: 25),
    ];
    
    for t in tests {
        if !t.test() {
            print(t);
            return false;
        }
    }
    return true;
}

testFrameIndex();
testSub2Idx();


while let jump = destination(knight: knight, indices: indices) {
    indices.insert(jump);
    sloanIndices.append(jump + 1);
    knight = idx2sub(idx: jump);
}

for idx in sloanIndices {
    print(idx);
}
