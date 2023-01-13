type t = {
    element: Element.t,
    health: float,
};

let empty = {
    element: Element.Paper,
    health: 100.,
}

let makeDamage = (t, damage) => { ...t, health: max(0., t.health -. damage) };
let setElement = (t, element) => { ...t, element }
