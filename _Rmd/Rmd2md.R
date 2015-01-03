
## might need to rebuild knitr to avoid "cairo graphics error
#library('devtools')
#install_github('yihui/knitr')
#library('knitr')

## source of code
#http://chepec.se/blog/2014/07/16/knitr-jekyll.html


#!/usr/bin/env Rscript
options(stringsAsFactors = FALSE)

# inspiration sources:
# http://www.jonzelner.net/jekyll/knitr/r/2014/07/02/autogen-knitr/
# http://gtog.github.io/workflow/2013/06/12/rmarkdown-to-rbloggers/


KnitPost <- function(site.path='/Users/abrooks/Documents/github/simpleblog/', overwriteAll=FALSE, overwriteOne=NULL) {
  library('knitr')
  # convert all Rmd files in _Rmd/* to markdown files
  
  # directory of jekyll blog (including trailing slash)
  site.path <- site.path
  # directory where your Rmd-files reside (relative to base)
  rmd.path <- paste0(site.path, "_Rmd")
  # directory to save figures
  fig.dir <- "assets/Rfig/"
  # directory for converted markdown files
  posts.path <- paste0(site.path, "_posts/articles/")
  # cache 
  cache.path <- paste0(site.path, "_cache")
  
  #library('knitr')
  render_jekyll(highlight = "pygments")
  # "base.dir is never used when composing the URL of the figures; it is 
  # only used to save the figures to a different directory, which can 
  # be useful when you do not want the figures to be saved under the
  # current working directory. 
  # The URL of an image is always base.url + fig.path"
  # https://groups.google.com/forum/#!topic/knitr/18aXpOmsumQ
  opts_knit$set(base.url = '/',
                base.dir = site.path)
  opts_chunk$set(fig.path   = fig.dir,
                 fig.width  = 8.5,
                 fig.height = 5.25,
                 dev        = 'svg',
                 cache      = FALSE, 
                 warning    = FALSE, 
                 message    = FALSE, 
                 cache.path = cache.path, 
                 tidy       = FALSE)   
  
  # setwd to base
  setwd(rmd.path)
  
  
  # some logic to help us avoid overwriting already existing md files
  files.rmd <- 
    data.frame(rmd = list.files(path = rmd.path,
                                full.names = TRUE,
                                pattern = "\\.Rmd$",
                                ignore.case = TRUE,
                                recursive = FALSE), stringsAsFactors=F)
  files.rmd$corresponding.md.file <- paste0(posts.path, "/", basename(gsub(pattern = "\\.Rmd$", replacement = ".md", x = files.rmd$rmd)))
  files.rmd$corresponding.md.exists <- file.exists(files.rmd$corresponding.md.file)
  files.rmd$md.overwriteAll <- overwriteAll
  if(is.null(overwriteOne)==F) files.rmd$md.overwriteAll[grep(overwriteOne, files.rmd[,'rmd'], ignore.case=T)] <- TRUE
  files.rmd$md.render <- FALSE
  for (i in 1:dim(files.rmd)[1]) {
    if (files.rmd$corresponding.md.exists[i] == FALSE) {
      files.rmd$md.render[i] <- TRUE
    }
    if ((files.rmd$corresponding.md.exists[i] == TRUE) && (files.rmd$md.overwriteAll[i] == TRUE)) {
      files.rmd$md.render[i] <- TRUE
    }
  }
  
  
  # For each Rmd file, render markdown (contingent on the flags set above)
  for (i in 1:dim(files.rmd)[1]) {
    # if clause to make sure we only re-knit if overwriteAll==TRUE or .md not already existing
    if (files.rmd$md.render[i] == TRUE) {
      # KNITTING ----
      #out.file <- basename(knit(files.rmd$rmd[i], envir = parent.frame(), quiet = TRUE))
      out.file <- knit(as.character(files.rmd$rmd[i]), 
                      output = as.character(files.rmd$corresponding.md.file[i]),
                      envir = parent.frame(), 
                      quiet = TRUE)
      message(paste0("KnitPost(): ", basename(files.rmd$rmd[i])))
    }     
  }
  
}


## actually using function
if(1==0) KnitPost(overwriteOne='new-york-times')
