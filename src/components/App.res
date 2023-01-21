@module external styles: {..} = "./app.module.css";

module Style = ReactDOM.Style;
module Store = Store.Store;

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
        <PlayerView player={left}>
            <ChoiceView choice={choosing.leftChoice} dispatch={dispatch} isLeft={true}/>
        </PlayerView>
        <PlayerView player={right}>
            <ChoiceView choice={choosing.rightChoice} dispatch={dispatch} isLeft={false} />
        </PlayerView>
    </>
}
