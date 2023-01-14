module Choice = Choosing.Choice;
module Move = Choosing.Move;

type action =
    | UpdateLeft(Move.t)
    | UpdateRight(Move.t)
    | ConfirmLeft
    | ConfirmRight
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

let updatePlayer = (
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
    }
}

let reduce = (state, action) => {
    let choosing = updateChoosing(state.choosing, action);
    let bothConfirmed = Choosing.areBothConfirmed(choosing);

    if bothConfirmed {
        let left = state.left->updatePlayer(choosing.leftChoice, state.right, choosing.rightChoice);
        let right = state.right->updatePlayer(choosing.rightChoice, state.left, choosing.leftChoice);
        let choosing = Choosing.empty;
        { left, right, choosing }
    } else {
        { ...state, choosing }
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
