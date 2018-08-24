package main

import "fmt"
import "os"

import "database/sql"
import _ "github.com/go-sql-driver/mysql"

// @see: https://stackoverflow.com/a/40326580
func getEnv(key, fallback string) string {
    if value, ok := os.LookupEnv(key); ok {
        return value
    }
    return fallback
}

func main() {
    var Host = os.Getenv("MYSQL_HOST")
    var Database = os.Getenv("MYSQL_DATABASE")
    var Username = os.Getenv("MYSQL_USER")
    var Password = os.Getenv("MYSQL_PASSWORD")

    var dsn = fmt.Sprintf("%s:%s@tcp(%s)/%s", Username, Password, Host, Database);

    db, err := sql.Open("mysql", dsn)
    if err != nil {
        panic(err.Error())
    }
    defer db.Close()

    stmtOut, err := db.Prepare("SELECT COUNT(*) FROM test WHERE TRUE;")
    if err != nil {
        panic(err.Error())
    }
    defer stmtOut.Close()

    var count int
    err = stmtOut.QueryRow().Scan(&count)
    if err != nil {
        panic(err.Error())
    }

    fmt.Printf("Count: %d\n", count)
}
