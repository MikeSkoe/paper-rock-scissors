@module external styles: {..} = "./app.module.css";

module Style = ReactDOM.Style;

module Select = BattleState.Select;

@react.component
let make = () =>
    <>
        <PlayerView getPlayer={Select.left}>
            <ChoiceView
                getChoice={Select.leftChoice}
                battleAction={action => SetLeft(action)}
            />
        </PlayerView>

        <PlayerView getPlayer={Select.right}>
            <ChoiceView
                getChoice={Select.rightChoice}
                battleAction={action => SetRight(action)}
            />
        </PlayerView>
    </>
