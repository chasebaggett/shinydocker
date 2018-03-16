Presentation
========================================================

Shiny is Awesome!
========================================================

- Fast Development
- Excellent Ecosystem
- ...but can be challenging to scale.

Problems with Open Source Shiny
========================================================

- All users share a single R session.
- With simple applications, a single session can support many users with minimal delay.
- With more complex applications, users end up waiting on each other. 


Solutions Available
========================================================

There are two products on the market that solve this problem. 

- Shiny Server Pro is supported by Rstudio as a commercial product and can be licenses from them.
- Shiny Proxy is developed by Open Analytics, is open source, and free (gratis & libre). 

We currently use ShinyProxy
========================================================

- No Concurrent User Limit
- Utilizes Docker for Scaling
- Built in LDAP Integration
- Requires Java
- Built in Usage Statistics
- Multiple Shiny Apps with Landing Page

Must Dockerize Shiny Apps
========================================================

Examples Files On How to Do this:
- https://github.com/chasebaggett/shinydocker
- Command then executed docker build -t app_name .
- Add the image name to your Shiny Proxy config file:
- https://www.shinyproxy.io/configuration/


Oh, my server ran out of memory...
========================================================

Shiny App on your desktop might read an RDS or CSV into memory on load.
* At scale, this presents two problems:
  + Load Time of File From Disk can Slow Down the App Launching
  + Each User holding a separate copy of the file in memory. 
    + 5GB file * 200 users…


Potential Solutions
========================================================

- SQL Servers are popular for holding the data and then on request the shiny app queries for what it needs.

- In my experience, you end up spending a significant amount of time designing your SQL database.

- Sometimes, this isn't necessary. 


Potential Solutions
========================================================

Many of my shiny applications follow a fairly simple design where users select something and the model/data/etc is filtered and all data is refit. This is such a simple design that a SQL database is overkill. 

Redis works really well for these types of tasks. 

How you Might Do it Today
========================================================

Load Data


```r
library(readxl)                                      
data = read_excel("Online Retail.xlsx")
data <- do.call("rbind", replicate(100, data, simplify = FALSE))

library(data.table)
dt <- as.data.table(data)
setkey(dt,StockCode)

start <- Sys.time()
trash <- subset(data,StockCode=="84029E")
Sys.time() - start
```

```
Time difference of 1.22172 secs
```

How you Might Do it Today
========================================================
Or maybe you like Data.Table


```r
start <- Sys.time()
trash <- dt[.("84029E")]
Sys.time() - start
```

```
Time difference of 0.008793354 secs
```


How you could do it with Redis
========================================================
Redis Set

```r
library(rredis)
redisConnect("redis")
for (k in unique(dt[[key(dt)]])){
  redisSet(as.character(k),dt[k])
}
```

How you could do it with Redis
========================================================

```r
start <- Sys.time()
trash <- redisGet("84029E")
Sys.time() - start
```

```
Time difference of 0.02478647 secs
```

```r
redisClose()
```
