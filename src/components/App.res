@react.component
let make = () => {
    {switch RescriptReactRouter.useUrl().path {
        | list{"result"} => <ResultComponent />
        | _ => <BattleComponent />
    }}
}
