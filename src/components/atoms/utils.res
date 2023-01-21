let classname = (names: array<string>): string => {
    names->Belt.Array.reduce("",
        (acc, curr) => acc ++ " " ++ curr
    )
}
