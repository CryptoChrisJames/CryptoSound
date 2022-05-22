const { application } = require("express");
const express = require("express");

const env = process.env.NODE_ENV;

const app = express();
app.get('/', (req,res) => {
    res.send("hElLo WOrLd").status(200);
});

const currentPORT = () => {
    if (env === "dev") {
        return "8100";
    }
    return process.env.PORT;
};

app.listen(currentPORT());