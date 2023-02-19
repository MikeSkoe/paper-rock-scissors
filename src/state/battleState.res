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

let reduce = (state, action): state  => {
    let choosing = switch action {
        | SetLeft(move) => Choosing.setLeft(move, state.choosing)
        | SetRight(move) => Choosing.setRight(move, state.choosing)
        | Apply => state.choosing
    }

    switch action {
        | Apply => choosing->Choosing.foldConfirmed(
            { ...state, choosing },
            (leftChoice, rightChoice) => ({
                left: state.left->Player.applyDamageToPlayer(
                    leftChoice,
                    state.right,
                    rightChoice,
                ),
                right: state.right->Player.applyDamageToPlayer(
                    rightChoice,
                    state.left,
                    leftChoice,
                ),
                choosing: Choosing.empty,
            }),
        )
        | _ => { ...state, choosing }
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
