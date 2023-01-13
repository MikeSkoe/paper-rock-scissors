type t = Rock | Paper | Scissors

/**
 * Get damage shift depending on winger vs victim elements
 * Example: Scissors -> Paper is higher damage than Paper -> Scissors
 */
let getCoeff: (t, t) => float

let toString: t => string
