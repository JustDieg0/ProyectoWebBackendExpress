const app = require('./app');

//global
app.set("port",process.env.PORT || 3001);

//server
app.listen(app.get("port"), () => {
    console.log(`Server Running at port ${app.get("port")}`);
})