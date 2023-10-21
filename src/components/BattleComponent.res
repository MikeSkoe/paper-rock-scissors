@module external styles: {..} = "./app.module.css";

module Style = ReactDOM.Style;

@react.component
let make = () => {
    let appAction = React.useContext(BattleStore.appActionContext);
    let setLeft = React.useCallback0(action => {
        action->BattleState.SetLeft->ReX.call(appAction, _);
    });
    let setRight = React.useCallback0(action => {
        appAction->ReX.call(action->BattleState.SetRight);
    });

    <>
        <PlayerView getPlayer={BattleState.Select.left}>
            <ChoiceView
                getChoice={BattleState.Select.leftChoice}
                dispatch={setLeft}
            />
        </PlayerView>

        <PlayerView getPlayer={BattleState.Select.right}>
            <ChoiceView
                getChoice={BattleState.Select.rightChoice}
                dispatch={setRight}
            />
        </PlayerView>
    </>
}
