module Move = Choosing.Move;

type t = {
    element: Element.t,
    health: float,
};

let empty = {
    element: Element.Paper,
    health: 1.,
}

%%private(
let makeDamage = (t, damage) => { ...t, health: max(0., t.health -. damage) };
let setElement = (t, element) => { ...t, element }
)

let updateElement = (playerMove: Move.t, player: t) => {
    let newElement = playerMove->Move.foldElement(player.element, e => e);

    player->setElement(newElement);
}

let updateDamage = (victim: t, winger: t, wingerMove: Move.t) => {
    let damage = wingerMove->Move.foldDice(0.0, dice => dice->Dice.toFloat);
    let coeff = winger.element->Element.getCoeff(victim.element);

    victim->makeDamage(damage *. coeff);
}

let applyDamageToPlayer = (
    victim,
    victimMove,
    winger,
    wingerMove,
) => {
    victimMove
        ->updateElement(victim)
        ->updateDamage(winger, wingerMove);
}
