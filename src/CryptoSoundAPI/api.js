const { application } = require("express");
const express = require("express");
const app = express();
app.get('/', (req,res) => {
    res.send("hElLo WOrLd").status(200);
});

if(process.env.NODE_ENV == 'prod') {

} else {
    app.listen(8100);
    console.log('CS API is running.');
}