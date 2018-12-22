package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, Message())
	})

	http.ListenAndServe(":8080", nil)
}

// Message returns Hello World
func Message() string {
	return "Hello World"
}
