@module external box: {..} = "../atoms/box.module.css"
@module external styles: {..} = "./player.module.css"

@react.component
let make = (~getPlayer: BattleState.state => Player.t, ~children) => {
    let app = React.useContext(BattleStore.appContext);
    let player = app->BattleStore.useSync(Player.empty, getPlayer);

    <div className={Utils.classname([box["box"], styles["player"]])}>
        <div>{`Element: ${player.element->Element.toString}`->React.string}</div>
        <progress value={player.health->Belt.Float.toString} step={0.01} max="1" />
        {children}
    </div>
}
