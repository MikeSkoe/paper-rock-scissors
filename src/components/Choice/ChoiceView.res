@module external hlist: {..} = "../atoms/hlist.module.css";

module Move = Choosing.Move;

open React;

@react.component
let make = (
    ~getChoice: BattleState.state => option<Move.t>,
    ~battleAction: Move.t => BattleState.action,
) => {
    let dispatch = useContext(BattleStore.dispatchContext);
    let app = useContext(BattleStore.appContext);
    let choice = app->BattleStore.useSync(None, getChoice);

    <div className={hlist["hlist"]}>
        {switch choice {
            | Some(Move.ChangeElement(element)) =>
                <button>{element->Element.toString->string}</button>
            | Some(Move.Attack(dice)) => <>
                <button>{"Attack"->string}</button>
                <button>{dice->Dice.toString->string}</button>
            </>
            | None => <>
                {[Element.Paper, Element.Rock, Element.Scissors]
                    ->Belt.Array.map(element =>
                        <button
                            key={element->Element.toString}
                            onClick={_ => dispatch->ReX.call(element->Move.ChangeElement->battleAction)}
                        >
                            {element->Element.toString->string}
                        </button>
                    )
                    ->array
                }

                <button onClick={_ => dispatch->ReX.call(Dice.getRandom()->Move.Attack->battleAction)}>
                    {"Attack"->string}
                </button>
            </>
        }}
    </div>
}
