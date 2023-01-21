@module external hlist: {..} = "../atoms/hlist.module.css";

module Move = Choosing.Move;

module ConfirmedC = {
    @react.component
    let make = (~move) => {
        switch move {
            | Move.ChangeElement(element) => <button>{element->Element.toString->React.string}</button>
            | Move.Attack(dice) => <>
                <button>{"Attack"->React.string}</button>
                <button>{dice->Dice.toString->React.string}</button>
            </>
        }
    }
}

module NotConfirmedC = {
    module Button = {
        @react.component
        let make = (~element, ~dispatch) => {
            <button onClick={_ => dispatch(Move.ChangeElement(element))}>
                {element->Element.toString->React.string}
            </button>
        }
    }

    @react.component
    let make = (~dispatch, ~isLeft) => {
        let updateDispatch = element => dispatch(isLeft ? State.SetLeft(element) : State.SetRight(element));
        let onAttackClick = _ => updateDispatch(Move.Attack(Dice.getRandom()))

        <>
            <Button element={Element.Paper} dispatch={updateDispatch} />
            <Button element={Element.Rock} dispatch={updateDispatch} />
            <Button element={Element.Scissors} dispatch={updateDispatch} />
            <button onClick={onAttackClick}>{"Attack"->React.string}</button>
        </>
    }
}

@react.component
let make = (~choice: option<Move.t>, ~dispatch, ~isLeft) => {
    <div className={hlist["hlist"]}>
        {switch choice {
            | Some(move) => <ConfirmedC move={move} />
            | None => <NotConfirmedC dispatch={dispatch} isLeft={isLeft} />
        }}
    </div>
}
