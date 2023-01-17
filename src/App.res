module Move = Choosing.Move;
module Style = ReactDOM.Style;
module Store = Store.Store;

module Divide = {
    @react.component
    let make = () => <br />
}

module PlayerC = {
    @react.component
    let make = (~player: Player.t) => {
        <div className="player">
            <div>{`Element: ${player.element->Element.toString}`->React.string}</div>
            <div>
                {`Health: `->React.string}
                <input value={player.health->Belt.Float.toString} min={"0"} max={"1"} step={0.01} type_="range" />
            </div>
        </div>
    }
}

module ChoiceC = {
    module ConfirmedC = {
        @react.component
        let make = (~move) => {
            switch move {
                | Move.ChangeElement(element) => <b>{element->Element.toString->React.string}</b>
                | Move.Attack(dice) => <div>
                    <b>{"Attack"->React.string}</b>
                    <p>{dice->Dice.toFloat->Belt.Float.toString->React.string}</p>
                </div>
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
    let make = (~choice: option<Move.t>, ~dispatch, ~isLeft) => switch choice {
        | Some(move) => <ConfirmedC move={move} />
        | None => <NotConfirmedC dispatch={dispatch} isLeft={isLeft} />
    }
}

@react.component
let make = () => {
    let left = Store.useSelector(State.Select.left);
    let right = Store.useSelector(State.Select.right);
    let bothConfirmed = Store.useSelector(
        state => state
            ->State.Select.choosing
            ->Choosing.foldConfirmed(false, (_, _) => true)
    );
    let choosing = Store.useSelector(State.Select.choosing);
    let dispatch = Store.useDispatch();

    React.useEffect1(_ => {
        if (bothConfirmed) {
            let timer = Js.Global.setTimeout(_ => dispatch(State.Apply), 2000);
            Some(_ => Js.Global.clearTimeout(timer))
        } else {
            None;
        }
    }, [bothConfirmed])

    <>
        <PlayerC player={left} />
        <Divide />
        <PlayerC player={right} />
        <Divide />
        <ChoiceC choice={choosing.leftChoice} dispatch={dispatch} isLeft={true}/>
        <Divide />
        <ChoiceC choice={choosing.rightChoice} dispatch={dispatch} isLeft={false} />
    </>
}
