const express = require("express")

const app = express()

app.get("*", (req, res) => {
    res.status(200).json("Hello World 1")
})

app.listen(80)