package main

import (
	"log"
	"os"
	"strings"

	"github.com/labstack/echo/v5"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/core"
)

func main() {
	app := pocketbase.New()

	// Configurar CORS
	app.OnBeforeServe().Add(func(e *core.ServeEvent) error {
		e.Router.AddMiddleware(func(c echo.Context) error {
			origin := c.Request().Header.Get("Origin")

			// Lista de orígenes permitidos
			allowedOrigins := []string{
				"https://cdf-lamorana.vercel.app",
				"http://localhost:3000",
				"http://localhost:4321",
				"http://127.0.0.1:4321",
			}

			// Verificar si el origen está permitido
			allowed := false
			for _, o := range allowedOrigins {
				if origin == o {
					allowed = true
					break
				}
			}

			if allowed {
				c.Response().Header().Set("Access-Control-Allow-Origin", origin)
			}

			c.Response().Header().Set("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE, OPTIONS, HEAD")
			c.Response().Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Pb-Auth")
			c.Response().Header().Set("Access-Control-Max-Age", "3600")

			// Handle preflight requests
			if c.Request().Method == "OPTIONS" {
				return c.NoContent(200)
			}

			return nil
		})
		return nil
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
