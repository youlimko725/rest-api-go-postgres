package main

import (
	"log"
	"os"
)

func main() {
	args := Args{
		conn: "postgres://user:password@localhost:5432/database?sslmode=disable", // postgres connection string
		port: ":8080",
	}
	// DB Connection
	if conn := os.Getenv("DB_CONN"); conn != "" {
		args.conn = conn
	}
	// Port
	if port := os.Getenv("PORT"); port != "" {
		args.port = port
	}
	// Run server
	if err := Run(args); err != nil {
		log.Println(err)
	}
}