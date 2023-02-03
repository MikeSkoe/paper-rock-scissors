@module external styles: {..} = "./app.module.css";

module Style = ReactDOM.Style;
module Store = Store.Store;

@react.component
let make = () => {
    let bothConfirmed = Store.useSelector(
        state => state
            ->State.Select.choosing
            ->Choosing.foldConfirmed(false, (_, _) => true)
    );
    let dispatch = Store.useDispatch();
    let setLeft = React.useCallback0(action => State.SetLeft(action)->dispatch);
    let setRight = React.useCallback0(action => State.SetRight(action)->dispatch);

    React.useEffect1(_ => {
        if (bothConfirmed) {
            let timer = Js.Global.setTimeout(_ => dispatch(State.Apply), 2000);
            Some(_ => Js.Global.clearTimeout(timer))
        } else {
            None;
        }
    }, [bothConfirmed]);

    <>
        <PlayerView getPlayer={State.Select.left}>
            <ChoiceView
                getChoice={State.Select.leftChoice}
                dispatch={setLeft}
            />
        </PlayerView>

        <PlayerView getPlayer={State.Select.right}>
            <ChoiceView
                getChoice={State.Select.rightChoice}
                dispatch={setRight}
            />
        </PlayerView>
    </>
}
