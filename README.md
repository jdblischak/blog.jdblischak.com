## distill blog

Start a new post:

```
distill::create_post(title = "name-of-post", date_prefix = NULL, draft = TRUE)
```

Build post for publication:

```
library(rmarkdown)
render("_posts/<post>/<post>.Rmd")
render_site(input = ".", encoding = "UTF-8")
```

* [distill docs](https://rstudio.github.io/distill/)

Only commit changes to the R Markdown files and other supporting files. The
HTML files in `_posts/` and all the files in `public/` are automatically built
and committed by GitHub Actions.

This site is configured to deploy the subdirectory `public/` in the Netlify
settings.

