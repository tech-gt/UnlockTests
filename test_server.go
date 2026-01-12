package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			// 读取请求体
			body, err := io.ReadAll(r.Body)
			if err != nil {
				http.Error(w, "Error reading request body", http.StatusBadRequest)
				return
			}
			defer r.Body.Close()

			// 解析 JSON
			var data map[string]interface{}
			if err := json.Unmarshal(body, &data); err != nil {
				http.Error(w, "Error parsing JSON", http.StatusBadRequest)
				return
			}

			// 美化输出接收到的数据
			prettyJSON, err := json.MarshalIndent(data, "", "  ")
			if err != nil {
				http.Error(w, "Error formatting JSON", http.StatusInternalServerError)
				return
			}

			fmt.Println("Received POST data:")
			fmt.Println(string(prettyJSON))

			// 返回成功响应
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusOK)
			fmt.Fprintf(w, `{"status": "success", "message": "Data received successfully"}`)
		} else {
			w.Header().Set("Content-Type", "application/json")
			fmt.Fprintf(w, `{"status": "running", "message": "POST server is running"}`)
		}
	})

	fmt.Println("Test server starting on http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
