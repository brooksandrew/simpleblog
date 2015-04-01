#' ---
#' title: Sample HTML report generated from R script
#' author: Andrew Brooks
#' date: March 4, 2015
#' output:
#'    html_document:
#'      toc: true
#'      highlight: zenburn
#' ---

#' ## Generate document body from comments
#' All the features from markdown and markdown supported within .Rmd documents, I was able to
#' get from within R scripts.  Here are some that I tested and use most frequently:  
#' 
#' * Smart comment fomatting in your R script generate the body and headers of the document
#'     * Simply tweak your comments to begin with `#'` instead of just `#`  
#' * Create markdown headers as normal: `#' #` for h1, `#' ##` for h2, etc.
#' * Add two spaces to the end of a comment line to start a new line (just like regular markdown)
#' * Add `toc: true` to YAML frontmatter to create a table of contents with links like the one at the 
#' top of this page that links to h1, h2 & h3's indented like so:
#'     * h1
#'         * h2
#'             * h3
#' * Modify YAML to change syntax highlighting style (I'm using zenburn), author, title, theme, and all the good stuff
#' you're used to setting in Rmd documents.
#' * Sub-bullets like the ones above are created by a `#' *` with 4 spaces per level of indentation.
#' * Surround text with `*` to *italicize*  
#' * Surround text with `**` to **bold**  
#' * Surround text with `***` to ***italicize & bold***  
#' * Skip lines with `#' <br>`
#' * Keep comments in code, but hide from printing in report with `#' <!-- this text will not print in report -->`  
#' * Add hyperlinks:
#'     * [Rmarkdown cheatsheet](http://rmarkdown.rstudio.com/RMarkdownCheatSheet.pdf)
#'     * [Rmarkdown Reference Guide](http://rmarkdown.rstudio.com/RMarkdownReferenceGuide.pdf)
#'     * [Compiling R notebooks from R Scripts](http://rmarkdown.rstudio.com/r_notebook_format.html)
#' 

# comments without the extra tick show up like this.  And get included in code blocks
# loading mtcars data
data(mtcars)

#' ## Messing with data
 
library('knitr')

#' ### 3 ways to print an object
#' ...specifically a data.frame in this case.  Ordered from least to most pretty (in my opinion).

print(head(mtcars))
knitr::kable(head(mtcars))
#' including `#+ results='asis'` chunk option for formatting
#+ results='asis'
knitr::kable(head(mtcars))

#' ### Plotting
plot(mtcars$mpg, mtcars$disp, col=mtcars$cyl, pch=19)

#' We can change the chunk options we would use for a code block using `knitr` by using a comment that starts with `#+`.
#' For example, to change the plot size, we can specify `#+ fig.width=4, fig.height=4` before plotting.  
#' <br>
#' A new chunk is automatically generated (chunk settings reset) whenever we add document text with `#'` or change.
#' However, it is possible to specify global chunk options, if desired.
#' chunk options again with `#+`.  

#' `#+ fig.width=4, fig.height=4` <!-- simply for illustrative purposes in the document-->
#+ fig.width=4, fig.height=4
plot(mtcars$mpg, mtcars$disp, col=mtcars$cyl, pch=19)


#' Small plots often render with strange resolution and relative sizings of labels, axes, etc.  The `dpi` chunk option can be used 
#' to fix this.  Just be sure to adjust the fig.width and fig.height accordingly.
#' 
#' **Bad plot: ** `#+ fig.width=2, fig.height=2`
#+ fig.width=2, fig.height=2
hist(mtcars$mpg)

#' **Good plot: ** `#+ fig.width=4, fig.height=4, dpi=50`
#+ fig.width=4, fig.height=4, dpi=50
hist(mtcars$mpg)

#' Generate a series of plots from a loop
#+ fig.width=3, fig.height=3
for(i in 1:ncol(mtcars)) hist(mtcars[,i], breaks=40, xlab='', main=names(mtcars)[i])

#' ### Let's build a random forest model  
#' ... and explore some model output.  First here's a big chunk of text from the random forest documentation:  
#' <br>
#' **Random forest documentation:**  
#' randomForest implements Breiman's random forest algorithm (based on Breiman and Cutler's original Fortran code) 
#' for classification and regression. It can also be used in unsupervised mode for assessing proximities among data points.  
#' <br>
#' **Note:**  
#' The forest structure is slightly different between classification and regression. For details on how the trees are stored, see the help page for getTree.    
#' <br>
#' If xtest is given, prediction of the test set is done “in place” as the trees are grown. If ytest is also given, and do.trace is set to some positive integer, 
#' then for every do.trace trees, the test set error is printed. Results for the test set is returned in the test component of the resulting randomForest object. 
#' For classification, the votes component (for training or test set data) contain the votes the cases received for the classes. If norm.votes=TRUE, the fraction 
#' is given, which can be taken as predicted probabilities for the classes.  
#' <br>
#' For large data sets, especially those with large number of variables, calling randomForest via the formula interface is not advised: There may be too 
#' much overhead in handling the formula.  
#' <br>
#' The “local” (or casewise) variable importance is computed as follows: For classification, it is the increase in percent of times a case is OOB 
#' and misclassified when the variable is permuted. For regression, it is the average increase in squared OOB residuals when the variable is permuted.  


# OK. now let's actually use random.forest
library('randomForest')
mtcars$am <- as.factor(mtcars$am)
rf <- randomForest(am~., ntree=100, data=mtcars)

#' Here's the resulting confusion matrix on the training data.  Not very clear to a non-technical or non-forest savvy audience.
print(rf)

#' ### Dynamic comments
#' We can get fancy and actually dynamically generate some commentary around these results.  That is we can auto-fill parts of our document text
#' with objects from the R environment.  This could be useful with analyses that involve stochastic 
#' elements changing from run to run like random forest.  Or any analysis where results are subject to change.    
#' <br>  
#' `r rf$confusion[1,1]` cars are correctly classified as 0.  
#' `r rf$confusion[2,2]` cars are correctly classified as 1.  
#' `r rf$confusion[1,2]` cars are misclassified as 1.  
#' `r rf$confusion[2,1]` cars are misclassified as 0.  
#' 
#' These numbers were generated by wrapping the R expression to excute into the ticks like so: 
#' I don't know how to write this within a `#'` comment without evaluating it, so I'm documenting here as a
#' character string:  
#+ echo=F, eval=T
cat("#' `r rf$confusion[2,1]` cars are misclassified as 0. ")
#' <br>
#' 
#' ### Generate comments in a loop
#' 
#' This is useful if you want to generate lots of text without writing it manually.  

#' `#+ results='asis'`
#+ results='asis'
for (i in 1:10) {
  rf <- randomForest(am~., ntree=100, data=mtcars)
  cat("iteration ",i, ": ", rf$confusion[1,1], "cars are correctly classified as 0", "\n")
  cat('\n')
}

#' ## Toggle chunk settings globally by R variables
#' Much like we used R objects to dynamically generate text to print in the document (in the form of comments),
#' we can use R objects to dynamically specify chunk options.  

#' When we set `evaluateStuff` to `TRUE` or `FALSE`, the following 3 chunks will evaluate (or not) as we choose.
#' We can toggle them all with one variable, instead of manually changing the chunk settings with `#+ eval=T`
#' in the R script multiple times.  Simply
#' include the variable you want to execute in the chunk comments with ticks.   
#' Like so:  **#+ eval=\`evaluateStuff\`**

evaluateStuff <- T

#+ eval=`evaluateStuff`
cat('first thing to evaluate')
#+ eval=`evaluateStuff`
cat('second thing to evaluate')
#+ eval=`evaluateStuff`
cat('third thing to evaluate')

#' <br>
#' Now let's just print the code and not evaluate anything.
evaluateStuff <- F

#+ eval=`evaluateStuff`
cat('first thing to evaluate')
#+ eval=`evaluateStuff`
cat('second thing to evaluate')
#+ eval=`evaluateStuff`
cat('third thing to evaluate')

#' ## Converting R Script to HTML/PDF  
#' If you did everyhing right, above this is the easy part.  Simply render the script as desired with the `render` function from `rmarkdown`.  

#' `rmarkdown::render('/Users/you/Documents/yourscript.R')`

