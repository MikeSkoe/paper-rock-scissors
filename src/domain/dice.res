type t = One | Two | Three | Four | Five | Six;

%%private(
    let part = 1.0 /. 6.;
    let one = part *. 1.;
    let two = part *. 2.;
    let three = part *. 3.;
    let four = part *. 4.;
    let five = part *. 5.;
    let six = 1.;
)

let toString = t => switch t {
    | One => "1️⃣"
    | Two => "2️⃣"
    | Three => "3️⃣"
    | Four => "4️⃣"
    | Five => "5️⃣"
    | Six => "6️⃣"
}

let toFloat = t => switch t {
    | One => one
    | Two => two
    | Three => three
    | Four => four
    | Five => five
    | Six => six
}

let getRandom = () => switch Js.Math.random() {
    | num if num <= one => One
    | num if num <= two => Two
    | num if num <= three => Three
    | num if num <= four => Four
    | num if num <= five => Five
    | _ => Six
}
