module Move = Choosing.Move;

type action =
    | SetLeft(Move.t)
    | SetRight(Move.t)
    | Apply
    ;

type state = {
    left: Player.t,
    right: Player.t,
    choosing: Choosing.t,
}

let updateElement = (player: Player.t, playerMove: Move.t) => {
    player->Player.setElement(
        playerMove->Move.foldElement(player.element, e => e),
    );
}

let updateDamage = (victim: Player.t, winger: Player.t, wingerMove: Move.t) => {
    let damage = wingerMove->Move.foldDice(
        0.0,
        dice => dice->Dice.toFloat,
    );
    let coeff = winger.element->Element.getCoeff(victim.element);
    victim->Player.makeDamage(damage *. coeff);
}

let applyDamageToPlayer = (
    victim,
    victimMove,
    winger,
    wingerMove,
) => {
    victim
        ->updateElement(victimMove)
        ->updateDamage(winger, wingerMove);
}

let updateChoosing = (choosing, action) => {
    switch action {
        | SetLeft(move) => choosing->Choosing.mapLeft(_ => Some(move))
        | SetRight(move) => choosing->Choosing.mapRight(_ => Some(move))
        | Apply => choosing
    }
}

let reduce = (state, action): state  => {
    switch action {
        | Apply => updateChoosing(state.choosing, action)->Choosing.foldConfirmed(
            { ...state, choosing: updateChoosing(state.choosing, action) },
            (leftChoice, rightChoice) => ({
                left: state.left->applyDamageToPlayer(leftChoice, state.right, rightChoice),
                right: state.right->applyDamageToPlayer(rightChoice, state.left, leftChoice),
                choosing: Choosing.empty,
            }),
        )
        | _ => { ...state, choosing: updateChoosing(state.choosing, action) }
    }
}

let empty = {
    left: Player.empty,
    right: Player.empty,
    choosing: Choosing.empty,
};

module Select = {
    let left = ({ left }) => left;
    let right = ({ right }) => right;
    let choosing = ({ choosing }) => choosing;
    let leftChoice = ({ choosing }) => choosing.leftChoice;
    let rightChoice = ({ choosing }) => choosing.rightChoice;
}
