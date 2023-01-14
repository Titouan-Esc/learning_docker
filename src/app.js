const express = require("express");
const mongoClient = require("mongodb").MongoClient;
let count;

// Se connecter sur un container en local avec le nom du container de la base de donnée
mongoClient.connect(
  `mongodb://${process.env.MONGO_USR}:${process.env.MONGO_PWD}@db`,
  { useUnifiedTopology: true },
  (err, client) => {
    if (err) {
      console.log(err);
    } else {
      console.log("Connection start");
      count = client.db("test").collection("count");
    }
  }
);

const app = express();

app.get("/err", (req, res) => {
    process.exit(0)
})

app.get("/", (req, res) => {
  count
    .findOneAndUpdate({}, { $inc: { count: 1 } }, { returnNewDocument: true })
    .then((doc) => {
      const count = doc.value;
      res.status(200).json(count.count);
    });
});

app.get("*", (req, res) => {
  res.end();
});

app.listen(80);
