@module external box: {..} = "../atoms/box.module.css"
@module external styles: {..} = "./player.module.css"

@react.component
let make = React.memo((~getPlayer: State.state => Player.t, ~children) => {
    let player = Store.Store.useSelector(getPlayer);

    <div className={Utils.classname([box["box"], styles["player"]])}>
        <div>{`Element: ${player.element->Element.toString}`->React.string}</div>
        <progress value={player.health->Belt.Float.toString} step={0.01} max="1" />
        {children}
    </div>
})
