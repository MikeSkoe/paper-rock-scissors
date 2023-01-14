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
                | Move.Attack => <b>{"Attack"->React.string}</b>
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
            let attackStyle = move === Move.Attack
                ? Style.make(~border="1px solid red", ())
                : Style.make(());
            let updateDispatch = element => dispatch(isLeft ? State.UpdateLeft(element) : State.UpdateRight(element));
            let confirmDispatch = _ => dispatch(isLeft ? State.ConfirmLeft : State.ConfirmRight);

            <>
                <Button element={Element.Paper} move={move} dispatch={updateDispatch} />
                <Button element={Element.Rock} move={move} dispatch={updateDispatch} />
                <Button element={Element.Scissors} move={move} dispatch={updateDispatch} />
                <button style={attackStyle} onClick={_ => updateDispatch(Move.Attack)}>
                    {"Attack"->React.string}
                </button>
                <button onClick={confirmDispatch}>
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
    let choosing = Store.useSelector(State.Select.choosing);
    let dispatch = Store.useDispatch();

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
