package main

import (
	"fmt"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, req *http.Request) {
	w.Write("hello world!\n")
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
