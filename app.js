// Az express könyvtár importálása, amely lehetővé teszi webalkalmazások fejlesztését Node.js-ben
const express = require('express');

// Létrehozzuk az express alkalmazást, amely alapértelmezés szerint HTTP szerverként fog működni
const app = express();

// Middleware hozzáadása, amely lehetővé teszi JSON típusú adatok fogadását a HTTP kérés törzséből
app.use(express.json()); // Minden bejövő kérés JSON formátumban lesz kezelve

// Az mysql2 könyvtár importálása, amely MySQL adatbázisokhoz való kapcsolódást tesz lehetővé
const mysql = require('mysql2');

// Létrehozzuk a MySQL adatbázis-kapcsolatot (host, port, felhasználó, jelszó, adatbázis)
const connection = mysql.createConnection({
    host: "127.0.0.1",  // Az adatbázis szerverének címe
    port: 3307, // Az adatbázis szerver portja
    user: "root",   // Az adatbázis felhasználói neve
    password: "",   // Az adatbázis felhasználói jelszava
    database: "pizza"   // Az adatbázis neve, amellyel kapcsolatba lépünk
});

// A connect metódus használata a MySQL adatbázishoz való kapcsolódás elindításához
connection.connect(function(err) {  // Az err paraméter tartalmazza a hibaüzenetet, ha a kapcsolat nem sikerül
    if (err) {  
        console.error('Hiba a kapcsolatban: ' + err.stack); // Kiírjuk a hibaüzenetet
        return; // Ha hiba történt, kilépünk a funkcióból
    }
    
    // Ha a kapcsolat sikeresen létrejött, akkor kiírjuk, hogy sikeres volt a kapcsolat
    console.log('Kapcsolódva az adatbázishoz.'); 
});

// HTTP GET kérés kezelése a '/pizza' útvonalra
// Ez a kód minden pizza adatot lekérdez az adatbázisból
app.get('/pizza', (req, res) => {

    // Az SQL lekérdezés, amely az összes pizzát (pazon, pnev, par) lekéri a "pizza" táblából
    let sql = 'SELECT pazon, pnev, par FROM pizza';

    // A lekérdezés végrehajtása az adatbázisban
    connection.query(sql, function(err, rows) {  // A rows tartalmazza az adatbázisból kapott sorokat

        if (err) {  // Ha hiba történik a lekérdezés során
            console.error(err);  // Kiírjuk a hibaüzenetet a konzolra
            res.status(500).send('Adatbázis hiba történt.');  // HTTP válaszként 500-as hibakódot küldünk, amely adatbázishibát jelez
            return;  // Ha hiba történt, kilépünk a funkcióból, és nem folytatjuk a válasz küldését
        }

        // Ha a lekérdezés sikeresen lefutott, a `rows` tartalmazza az eredményt
        res.send(rows);  // Válaszként visszaküldjük a lekérdezett adatokat
    }); 
});

// A lekérdezés a paraméterben átadott pizza ID alapján egy pizza adatot kér le az adatbázisból
app.get('/pizza/:id', (req, res) => {
    // Kinyerjük az id paramétert a URL-ből (pl. /pizza/1 -> req.params.id = 1)
    let id = req.params.id;

    // SQL lekérdezés, amely az adott pizza id-ja alapján egy pizza adatot keres
    let sql = 'SELECT pazon, pnev, par FROM pizza WHERE pazon = ?';
    let sqlParams = [id];  // Az SQL paraméterek: a kérésben átadott id

    // Lekérdezés végrehajtása az adatbázisban
    connection.query(sql, sqlParams, function(err, rows) { 
        if (err) {  // Ha hiba történik a lekérdezés során
            console.error(err);  // Kiírjuk a hibaüzenetet a konzolra
            res.status(500).send('Adatbázis hiba történt.');  // HTTP 500 hiba válasz küldése
            return;  // A hiba után kilépünk, a válasz nem folytatódik
        }

        // A lekérdezés sikeres volt, visszaküldjük az adatokat
        res.send(rows);  
    });
});

// Az új pizza adatokat a kliens küldi a kérés törzsével
app.post('/pizza', (req, res) => {
    // Az új pizza adatai a kérés törzséből jönnek
    let uj = req.body;  // Kinyerjük a pizza nevét és árát a kérés törzséből

    // SQL lekérdezés az új pizza felvételéhez az adatbázisba
    // A pazon auto-increment, így nem szükséges manuálisan megadni
    let sql = 'INSERT INTO pizza (pazon, pnev, par) VALUES (NULL, ?, ?)';
    let sqlParams = [uj.pnev, uj.par];  // Az új pizza neve és ára

    // Lekérdezés végrehajtása az adatbázisban
    connection.query(sql, sqlParams, function(err, rows) {
        if (err) {  // Ha hiba történik az adatbázis művelet közben
            console.error(err);  // Kiírjuk a hibaüzenetet
            res.status(500).send('Adatbázis hiba történt.');  // HTTP 500 válasz küldése
            return;  // A hiba után kilépünk
        }

        // A beszúrt sor ID-jának lekérése (az auto-increment miatt)
        let lastInsertId = rows.insertId;
        // Válaszként küldjük vissza az új pizza ID-ját és adatait
        res.status(201).send(lastInsertId, rows.pnev, rows.par);
    });
});

// A módosítandó pizza ID-t az URL paraméterből, a módosítandó adatokat pedig a kérés törzséből kapjuk
app.put('/pizza/:id', (req, res) => {
    // Kinyerjük az id paramétert az URL-ből
    let id = req.params.id;

    // Az új pizza adatai a kérés törzséből jönnek
    let uj = req.body;

    // SQL lekérdezés a pizza módosításához (az ID alapján)
    let sql = 'UPDATE pizza SET pnev = ?, par = ? WHERE pazon = ?';
    let sqlParams = [uj.pnev, uj.par, id];  // Az új név, ár és a módosítandó pizza ID

    // Lekérdezés végrehajtása az adatbázisban
    connection.query(sql, sqlParams, function(err, rows) {
        if (err) {  // Ha hiba történik a módosítás közben
            console.error(err);  // Kiírjuk a hibaüzenetet
            res.status(500).send('Adatbázis hiba történt.');  // HTTP 500 válasz
            return;  // Kilépünk, nem folytatjuk a kódot
        }

        // Ha sikeres volt a módosítás, visszaküldjük a módosított adatokat
        res.status(201).send(rows);
    });
});

// A törlendő pizza ID-t az URL-ből kapjuk
app.delete('/pizza/:id', (req, res) => {
    // Kinyerjük az id paramétert az URL-ből
    let id = req.params.id;

    // SQL lekérdezés a pizza törléséhez az adatbázisból
    let sql = 'DELETE FROM pizza WHERE pazon = ?';
    let sqlParams = [id];  // A törlendő pizza ID-ja

    // Lekérdezés végrehajtása az adatbázisban
    connection.query(sql, sqlParams, function(err, rows) {
        if (err) {  // Ha hiba történik a törlés során
            console.error(err);  // Kiírjuk a hibaüzenetet
            res.status(500).send('Adatbázis hiba történt.');  // HTTP 500 válasz
            return;  // Kilépünk, nem folytatjuk a kódot
        }

        // Ha a törlés sikeres volt, visszaküldjük a törlés eredményét 
        res.status(201).send(rows);
    });
});

//  A szerver elindítása a 3000-es porton 
app.listen(3000, () => {
    console.log('A szerver elindult a 3000-es porton.');
});


/*  
    Express
    Az express keretrendszer egy ingyenes, nyílt forráskódú, többplatformos JavaScript futtatókörnyezet, 
    amely lehetővé teszi a fejlesztők számára szerverek, webalkalmazások, parancssori eszközök és szkriptek létrehozását.

    Middlewares
    Olyan funkciók (függvények), amelyek hozzáférést biztosítanak a bejövő kérésekhez és módosíthatják azokat, 
    illetve válaszokat generálhatnak vagy átadhatják a vezérlést a következő middleware-nek a láncban. 
    A middleware-ek alapvető szerepet játszanak az alkalmazás logikájának kezelésében és szervezésében.
*/