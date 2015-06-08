package main

import (
    "fmt"
	"log"
    "code.google.com/p/gcfg"
)

type ConfigFree struct {
    User string
    Key string
}

type configFile struct {
    Free ConfigFree
}

type Config struct {
    Free struct {
            Free_mobile_api_user string
            Free_mobile_api_key string
    }
	
}


func main() {
	var cfg Config
	err := gcfg.ReadFileInto(&cfg, "../config.properties")
	fmt.Println(cfg.Free.Free_mobile_api_key)
	if err != nil {
		log.Fatalf("Failed to parse gcfg data: %s", err)
	}
}