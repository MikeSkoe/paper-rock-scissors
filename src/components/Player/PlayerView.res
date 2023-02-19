@module external box: {..} = "../atoms/box.module.css"
@module external styles: {..} = "./player.module.css"

@react.component
let make = (~getPlayer: BattleState.state => Player.t, ~children) => {
    let player = BattleStore.Store.useSelector(getPlayer);

    React.useEffect1(() => {
        let timer = ref(None);

        if player.health <= 0. {
            timer.contents = Some(Js.Global.setTimeout(_ => RescriptReactRouter.replace("result"), 1000));
        }

        timer.contents
            ->Belt.Option.map(timer => () => Js.Global.clearTimeout(timer));
    }, [player.health <= 0.])

    <div className={Utils.classname([box["box"], styles["player"]])}>
        <div>{`Element: ${player.element->Element.toString}`->React.string}</div>
        <progress value={player.health->Belt.Float.toString} step={0.01} max="1" />
        {children}
    </div>
}
