

env "local" {
  src = "file://database/schema"
  
  url = "postgresql://root:root@localhost:25433/practice?sslmode=disable&search_path=practice_app"
  

  dev = "postgresql://root:root@localhost:25433/practice?sslmode=disable&search_path=practice_app"
  

  migration {
    dir = "file://database/migrations"
  }
  

  format {
    migrate {
      diff = "{{ sql . \"  \" }}"
    }
  }
}


