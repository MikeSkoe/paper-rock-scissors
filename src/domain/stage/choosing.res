type move = ChangeElement(Element.t) | Attack;
type choice = {
    move: move,
    confirmed: bool,
};
type t = {
    leftChoice: choice,
    rightChoice: choice,
}

let emptyChoice = {
    move: Attack,
    confirmed: false,
}

let empty = {
    leftChoice: emptyChoice,
    rightChoice: emptyChoice,
};

let mapLeft = (t, fn) => { ...t, leftChoice: fn(t.leftChoice) }
let mapRight = (t, fn) => { ...t, rightChoice: fn(t.rightChoice) }

let setMove = (move, choice) => { ...choice, move }
let setConfirmed = (confirmed, choice) => { ...choice, confirmed }

let updateLeft = (t, move) => t->mapLeft(setMove(move))
let updateRight = (t, move) => t->mapRight(setMove(move))
let confirmLeft = mapLeft(_, setConfirmed(true));
let confirmRight = mapRight(_, setConfirmed(true));

let bothConfirmed = t => t.leftChoice.confirmed && t.rightChoice.confirmed;

let getDamage = choice =>
    choice.confirmed && choice.move == Attack
        ? 25.
        : 0.;

let foldElement = (choice: choice, default: 'a, fn: (Element.t) => 'a): 'a => switch choice.move {
    | ChangeElement(element) if choice.confirmed == true => fn(element)
    | _ => default
}
