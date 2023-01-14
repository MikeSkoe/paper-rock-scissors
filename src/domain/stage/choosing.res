module Move = {
    type t = ChangeElement(Element.t) | Attack;
}

module Choice = {
    type t = {
        move: Move.t,
        confirmed: bool,
    };

    let empty = {
        move: Attack,
        confirmed: false,
    }

    let setMove = (choice, move) => { ...choice, move }
    let setConfirmed = (choice, confirmed) => { ...choice, confirmed }

    let getDamage = choice =>
        choice.confirmed && choice.move == Attack
            ? 25.
            : 0.;

    let foldElement = (choice, default, update) => switch choice.move {
        | ChangeElement(element) if choice.confirmed == true => update(element)
        | _ => default
    }
}

type t = {
    leftChoice: Choice.t,
    rightChoice: Choice.t,
}

let empty = {
    leftChoice: Choice.empty,
    rightChoice: Choice.empty,
};

%%private(
let mapLeft = (t, fn) => { ...t, leftChoice: fn(t.leftChoice) }
let mapRight = (t, fn) => { ...t, rightChoice: fn(t.rightChoice) }
)

let updateLeft = (t, move) => t->mapLeft(Choice.setMove(_, move))
let updateRight = (t, move) => t->mapRight(Choice.setMove(_, move))
let confirmLeft = mapLeft(_, Choice.setConfirmed(_, true));
let confirmRight = mapRight(_, Choice.setConfirmed(_, true));

let areBothConfirmed = t => t.leftChoice.confirmed && t.rightChoice.confirmed;
