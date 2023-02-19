@react.component
let make = () => <>
    <h1>{"You won"->React.string}</h1>
    <button onClick={_ => RescriptReactRouter.replace("battle")}>
        {"Start over"->React.string}
    </button>
</>