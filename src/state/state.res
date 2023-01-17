module Choice = Choosing.Choice;
module Move = Choosing.Move;

type action =
    | UpdateLeft(Move.t)
    | UpdateRight(Move.t)
    | ConfirmLeft
    | ConfirmRight
    | Apply
    ;

type state = {
    left: Player.t,
    right: Player.t,
    choosing: Choosing.t,
}

let updateElement = (player: Player.t, playerChoice) => {
    let element = playerChoice->Choice.foldElement(player.element, e => e);
    player->Player.setElement(element);
}

let updateDamage = (victim: Player.t, winger: Player.t, wingerChoice) => {
    let damage = wingerChoice->Choice.getDamage;
    let coeff = winger.element->Element.getCoeff(victim.element);
    victim->Player.makeDamage(damage *. coeff);
}

let applyDamageToPlayer = (
    victim,
    victimChoice,
    winger,
    wingerChoice,
) => {
    victim
        ->updateElement(victimChoice)
        ->updateDamage(winger, wingerChoice);
}

let updateChoosing = (choosing, action) => {
    choosing->switch action {
        | UpdateLeft(move) => Choosing.updateLeft(_, move)
        | UpdateRight(move) => Choosing.updateRight(_, move)
        | ConfirmLeft => Choosing.confirmLeft
        | ConfirmRight => Choosing.confirmRight
        | Apply => (choosing => choosing)
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
}
