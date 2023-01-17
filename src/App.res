module Move = Choosing.Move;
module Choice = Choosing.Choice;
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
                <input value={player.health->Belt.Float.toString} min={"0"} max={"100"} type_="range" />
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
            let make = (~element, ~move, ~dispatch) => {
                let elementStyle = element => Move.ChangeElement(element) == move
                    ? Style.make(~border="1px solid red", ())
                    : Style.make(());

                <button
                    style={elementStyle(element)}
                    onClick={_ => dispatch(Move.ChangeElement(element))}
                >
                    {element->Element.toString->React.string}
                </button>
            }
        }

        @react.component
        let make = (~move, ~dispatch, ~isLeft) => {
            let attackStyle = switch move {
                | Move.Attack(_) => Style.make(~border="1px solid red", ())
                | Move.ChangeElement(_) => Style.make(())
            }
            let updateDispatch = element => dispatch(isLeft ? State.UpdateLeft(element) : State.UpdateRight(element));
            let onConfirmClick = _ => dispatch(isLeft ? State.ConfirmLeft : State.ConfirmRight);
            let onAttackClick = _ => updateDispatch(Move.Attack(Dice.getRandom()))

            <>
                <Button element={Element.Paper} move={move} dispatch={updateDispatch} />
                <Button element={Element.Rock} move={move} dispatch={updateDispatch} />
                <Button element={Element.Scissors} move={move} dispatch={updateDispatch} />
                <button style={attackStyle} onClick={onAttackClick}>
                    {"Attack"->React.string}
                </button>
                <button onClick={onConfirmClick}>
                    {"Confirm"->React.string}
                </button>
            </>
        }
    }

    @react.component
    let make = (~choice: Choice.t, ~dispatch, ~isLeft) => {
        choice.confirmed
            ? <ConfirmedC move={choice.move} />
            : <NotConfirmedC move={choice.move} dispatch={dispatch} isLeft={isLeft} />
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
