/* All possible moves that player can perform */
type move = ChangeElement(Element.t) | Attack
type choice = {
    move: move,
    confirmed: bool,
}
/* Type that represents temporary data while choosing stage */
type t = {
    leftChoice: choice,
    rightChoice: choice,
}

/* Empty values */
let emptyChoice: choice
let empty: t

/* modification API */
let updateLeft: (t, move) => t
let updateRight: (t, move) => t
let confirmLeft: t => t
let confirmRight: t => t

/* utils (should be public?) */
let bothConfirmed: t => bool
let getDamage: choice => float
let foldElement: (choice, 'a, Element.t => 'a) => 'a
