package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
)

func main() {
	filename := filepath.Base(os.Args[0])
	fmt.Printf("*** This works! %s\n", filename)

	f, err := os.OpenFile("results.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Println(err)
	}
	defer f.Close()

	logger := log.New(f, "", log.LstdFlags)
	logger.Printf("File '%s' works\n", filename)
}
