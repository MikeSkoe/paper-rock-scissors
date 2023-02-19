module Move = {
    type t =
        | ChangeElement(Element.t)
        | Attack(Dice.t);
    
    let foldElement = (t: t, defaultElement: 'a, fn: Element.t => 'a) => switch t {
        | ChangeElement(element) => fn(element)
        | _ => defaultElement
    }

    let foldDice = (t: t, defaultDice: 'a, fn: Dice.t => 'a) => switch t {
        | Attack(dice) => fn(dice)
        | _ => defaultDice
    }
}

type t = {
    leftChoice: option<Move.t>,
    rightChoice: option<Move.t>,
}

let empty = {
    leftChoice: None,
    rightChoice: None,
};

%%private(
let mapLeft = (t, fn) => { ...t, leftChoice: fn(t.leftChoice) }
let mapRight = (t, fn) => { ...t, rightChoice: fn(t.rightChoice) }
)

let foldConfirmed: (t, 'a, (Move.t, Move.t) => 'a) => 'a
    = (t, default, fn) => switch (t.leftChoice, t.rightChoice) {
        | (Some(leftChoice), Some(rightChoice)) => fn(leftChoice, rightChoice)
        | _ => default
    }

let setLeft: (Move.t, t) => t
    = (move, choosing) => choosing->mapLeft(_ => Some(move));

let setRight: (Move.t, t) => t
    = (move, choosing) => choosing->mapRight(_ => Some(move));
