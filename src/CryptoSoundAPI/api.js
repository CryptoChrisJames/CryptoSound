const { application } = require("express");
const express = require("express");

const env = process.env.NODE_ENV;

const app = express();
app.get('/', (req,res) => {
    res.send(`CS API in ${process.env.NODE_ENV} now listening on port ${process.env.PORT}`).status(200);
});

const currentPORT = () => {
    if (env === "dev") {
        return "8100";
    }
    console.log(`CS API in ${process.env.NODE_ENV} now listening on port ${process.env.PORT}`);
    return process.env.PORT;
};

app.listen(currentPORT());