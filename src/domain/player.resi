type t = {
    element: Element.t,
    health: float,
}

let empty: t

let makeDamage: (t, float) => t
let setElement: (t, Element.t) => t
