@module external hlist: {..} = "../atoms/hlist.module.css";

module Move = Choosing.Move;

@react.component
let make = (
    ~getChoice: BattleState.state => option<Move.t>,
    ~dispatch: Move.t => unit,
) => {
    let choice = BattleStore.AppContext.useSelect(getChoice);

    <div className={hlist["hlist"]}>
        {switch choice {
            | Some(Move.ChangeElement(element)) =>
                <button>{element->Element.toString->React.string}</button>
            | Some(Move.Attack(dice)) => <>
                <button>{"Attack"->React.string}</button>
                <button>{dice->Dice.toString->React.string}</button>
            </>
            | None => <>
                {[Element.Paper, Element.Rock, Element.Scissors]
                    ->Belt.Array.map(element =>
                        <button
                            key={element->Element.toString}
                            onClick={_ => element->Move.ChangeElement->dispatch}
                        >
                            {element->Element.toString->React.string}
                        </button>
                    )
                    ->React.array
                }
                <button onClick={_ => Dice.getRandom()->Move.Attack->dispatch}>
                    {"Attack"->React.string}
                </button>
            </>
        }}
    </div>
}
