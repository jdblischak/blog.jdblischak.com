## distill blog

Start a new post:

```
distill::create_post(title = "name-of-post", date_prefix = NULL, draft = TRUE)
```

Build post for publication:

```
library(rmarkdown)
render("_posts/<post>/<post>.Rmd")
render_site(input = "index.Rmd", encoding = "UTF-8")
```

* [distill docs](https://rstudio.github.io/distill/)
