const express = require("express");
const app = express();
const port = 6969;

app.set("view engine", "ejs");
app.use(express.static("public"));

app.get("/", (req, res) => {
  res.status(200).render("index", { layout: false });
});

app.listen(port, () => {
  console.log(`App listening at port ${port}`);
});
